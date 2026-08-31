variable "project_name" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "lambda_security_group_id" {
  type        = string
}

variable "jenkins_private_ip" {
  type        = string
}

variable "jenkins_job_name" {
  type        = string
  default     = "clinic-cd"
}

variable "jenkins_user" {
  type        = string
  sensitive   = true
}

variable "jenkins_api_token" {
  type        = string
  sensitive   = true
}

variable "image_tag" {
  type        = string
  default     = "latest"
}

variable "app_asg_name" {
  type        = string
}