provider "aws" {
  region = var.region
}

resource "aws_db_instance" "RDS" {
  identifier            = var.db_identifier
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  multi_az             = var.multi_az
  username             = var.db_username
  password             = var.db_password
  db_name              = var.db_name
  publicly_accessible  = var.publicly_accessible
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot = var.skip_final_snapshot
  apply_immediately    = var.apply_immediately
  tags = {
    Name = "RDS instance for ${var.db_name}"
  }
}
