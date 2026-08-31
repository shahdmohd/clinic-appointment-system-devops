variable "project_name" {
  type        = string
}

variable "ami_id" {
  type        = string
  default     = null
}

variable "instance_type" {
  type        = string
}

variable "public_subnet_id" {
  type        = string
}

variable "security_group_id" {
  type        = string
}

variable "instance_profile_name" {
  type        = string
}

variable "key_name" {
  type        = string
}

variable "root_volume_size" {
  type        = number
  default     = 30
}