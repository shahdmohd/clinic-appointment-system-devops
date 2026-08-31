output "asg_high_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.asg_high_cpu.alarm_name
}

output "alb_5xx_alarm_name" {
  value = aws_cloudwatch_metric_alarm.alb_5xx.alarm_name
}

output "target_5xx_alarm_name" {
  value = aws_cloudwatch_metric_alarm.target_5xx.alarm_name
}

output "rds_high_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.rds_high_cpu.alarm_name
}

output "rds_low_storage_alarm_name" {
  value = aws_cloudwatch_metric_alarm.rds_low_storage.alarm_name
}