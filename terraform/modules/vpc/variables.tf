# VPC
variable "vpc_cidr_block" {
  type = string
}

variable "project_name" {
  type = string
}

# Availability Zones
variable "availability_zones" {
  type = list(string)
}

# Public Subnets
variable "public_subnet_cidrs" {
  type = list(string)
}

# Private Subnets
variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_rds_subnet_cidrs" {
  type = list(string)
}