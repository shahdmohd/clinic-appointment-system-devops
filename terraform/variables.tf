variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "project_name" {
  type = string
}

#========================================================================
# VPC Module

# VPC
variable "vpc_cidr_block" {
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

#========================================================================
# ECR Module
variable "repository_name" {
  type = string
}

#========================================================================
# Launch Template Module
variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

#========================================================================
# RDS Module
variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = map(string)

  default = {
    Project     = "clinic"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

#========================================================================
# Key Pair
variable "key_name" {
  type = string
}

#=========================================================================
# Bastion
variable "bastion_instance_type" {
  type = string
}

#=========================================================================
# Security Groups
variable "github_webhook_cidrs" {
  description = "GitHub webhook CIDR ranges allowed to access Jenkins"
  type        = list(string)
  default     = []
}

#=========================================================================
# Lambda
variable "jenkins_user" {
  type      = string
  sensitive = true
}

variable "jenkins_api_token" {
  type      = string
  sensitive = true
}