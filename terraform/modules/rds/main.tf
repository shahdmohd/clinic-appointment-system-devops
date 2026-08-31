resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier = "${var.project_name}-postgres-db"

  allocated_storage = 20
  db_name           = "clinic"
  engine            = "postgres"
  engine_version    = "16.3"
  instance_class    = "db.t4g.micro"

  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  publicly_accessible    = false
  vpc_security_group_ids = [var.rds_security_group_id]

  username = var.db_username
  password = var.db_password

  skip_final_snapshot = true
}