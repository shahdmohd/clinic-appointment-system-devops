output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "jenkins_sg_id" {
  value       = aws_security_group.jenkins_sg.id
}

output "lambda_jenkins_trigger_sg_id" {
  value       = aws_security_group.lambda_jenkins_trigger_sg.id
}