output "rds_identifier" {
  value = aws_db_instance.rds_instance.identifier
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.address
}

output "rds_port" {
  value = aws_db_instance.rds_instance.port
}

output "rds_db_name" {
  value = aws_db_instance.rds_instance.db_name
}