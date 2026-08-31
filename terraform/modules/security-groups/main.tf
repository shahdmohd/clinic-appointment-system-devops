data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  my_public_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}

# ALB
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP/HTTPS inbound traffic to ALB and allow all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


resource "aws_vpc_security_group_egress_rule" "alb_all_outbound_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# App
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow traffic from ALB and allow all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_custom_tcp_ipv4" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8000
  ip_protocol                  = "tcp"
  to_port                      = 8000
}

resource "aws_vpc_security_group_egress_rule" "app_all_outbound_ipv4" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  description                  = "Allow SSH from bastion to app EC2 instances"
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

# RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow traffic from App and allow all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_custom_tcp_ipv4" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "rds_all_outbound_ipv4" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Bastion
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_from_my_ip" {
  security_group_id = aws_security_group.bastion_sg.id
  description       = "Allow SSH to bastion from current public IP"
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_outbound_ipv4" {
  security_group_id = aws_security_group.bastion_sg.id
  description       = "Allow all outbound traffic from bastion"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh_from_my_ip" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow SSH to Jenkins from current public IP"
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ui_from_my_ip" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow Jenkins UI from current public IP"
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "jenkins_all_outbound_ipv4" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow all outbound traffic from Jenkins"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_jenkins" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow SSH to app EC2s from Jenkins"
  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_webhook_from_github" {
  for_each = toset(var.github_webhook_cidrs)

  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow Jenkins webhook access from GitHub"
  cidr_ipv4         = each.value
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# Lambda that triggers Jenkins CD after ASG launch events
resource "aws_security_group" "lambda_jenkins_trigger_sg" {
  name        = "${var.project_name}-lambda-jenkins-trigger-sg"
  description = "Security group for Lambda that triggers Jenkins"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-lambda-jenkins-trigger-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "lambda_to_jenkins_8080" {
  security_group_id            = aws_security_group.lambda_jenkins_trigger_sg.id
  description                  = "Allow Lambda to call Jenkins on port 8080"
  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_8080_from_lambda" {
  security_group_id            = aws_security_group.jenkins_sg.id
  description                  = "Allow Jenkins webhook/API access from Lambda"
  referenced_security_group_id = aws_security_group.lambda_jenkins_trigger_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}