variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "github_webhook_cidrs" {
  description = "GitHub webhook CIDR ranges allowed to access Jenkins"
  type        = list(string)
  default     = []
}