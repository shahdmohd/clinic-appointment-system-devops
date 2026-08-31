resource "aws_launch_template" "ec2_launch_template" {
  name_prefix = "${var.project_name}-clinic-lt-"

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-app-instance"
      Project = var.project_name
      Role    = "app"
    }
  }
}