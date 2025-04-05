terraform {
  backend "s3" {
    bucket = "hula-hoop-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "security"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  cidr = var.vpc_cidr
  availability_zone = var.availability_zones
  private_subnet = var.private_subnets
  public_subnet = var.public_subnets
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster-version
  node_group = var.node_group
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet
}

module "rds" {
  source = "./modules/rds"
  db_instance_class = var.instance_class
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_engine = var.db_engine
  vpc_security_group_ids = module.security_group.security_group_id
  allocated_storage = var.allocated_storage
  region = var.region
  db_engine_version = var.db_engine_version
  db_subnet_group_name = module.security_group.db_subnet_group_name
  db_identifier = var.db_identifier
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  region = var.region
  sg_name = var.cluster_name
}