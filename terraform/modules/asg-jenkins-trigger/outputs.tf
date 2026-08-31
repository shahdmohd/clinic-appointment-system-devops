output "lambda_function_name" {
  value       = aws_lambda_function.asg_jenkins_trigger.function_name
}

output "eventbridge_rule_name" {
  value       = aws_cloudwatch_event_rule.asg_launch_success.name
}