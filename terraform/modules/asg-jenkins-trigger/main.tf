data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-asg-jenkins-trigger-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-asg-jenkins-trigger-lambda-role"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "asg_jenkins_trigger" {
  function_name = "${var.project_name}-asg-jenkins-trigger"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  environment {
    variables = {
      JENKINS_URL       = "http://${var.jenkins_private_ip}:8080"
      JENKINS_JOB       = var.jenkins_job_name
      JENKINS_USER      = var.jenkins_user
      JENKINS_API_TOKEN = var.jenkins_api_token
      IMAGE_TAG         = var.image_tag
    }
  }

  tags = {
    Name        = "${var.project_name}-asg-jenkins-trigger"
    Project     = var.project_name
  }
}

resource "aws_cloudwatch_event_rule" "asg_launch_success" {
  name        = "${var.project_name}-asg-launch-success"
  description = "Trigger Jenkins CD when ASG launches a new EC2 instance"

  event_pattern = jsonencode({
    source      = ["aws.autoscaling"]
    detail-type = ["EC2 Instance Launch Successful"]
    detail = {
      AutoScalingGroupName = [var.app_asg_name]
    }
  })

  tags = {
    Name        = "${var.project_name}-asg-launch-success"
    Project     = var.project_name
  }
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.asg_launch_success.name
  target_id = "${var.project_name}-asg-jenkins-trigger"
  arn       = aws_lambda_function.asg_jenkins_trigger.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_jenkins_trigger.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.asg_launch_success.arn
}