provider "aws" {
  region = var.region
}

resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = "SecurutyGroup for cluster"
  }
}

resource "aws_db_subnet_group" "OnFinance" {
  name       = "${var.sg_name}-db-subnet-group"
  subnet_ids = var.private_subnets
  tags = {
    Name = "${var.sg_name}-db-subnet-group"
  }
}