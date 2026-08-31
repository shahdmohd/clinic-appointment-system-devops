output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.app.arn_suffix
}