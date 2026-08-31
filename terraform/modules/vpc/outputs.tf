output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs for ALB and NAT"
}

output "private_app_subnet_ids" {
  value       = aws_subnet.app_private_subnet[*].id
  description = "Private app subnet IDs for EC2/ASG"
}

output "private_rds_subnet_ids" {
  value       = aws_subnet.rds_private_subnet[*].id
  description = "Private RDS subnet IDs"
}