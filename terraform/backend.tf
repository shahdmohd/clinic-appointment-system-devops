terraform {
  backend "s3" {
    bucket         = "clinic-terraform-state-724413959426-us-east-1"
    key            = "clinic/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "clinic-terraform-locks"
  }
}