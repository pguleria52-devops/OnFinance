variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "Availability zones"
  type = list(string)
  default = [ "us-east-1a","us-east-1b","us-east-1c" ]
}
variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
}
variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type = list(string)
  default = [ "10.0.4.0/24","10.0.5.0/24","10.0.6.0/24" ]
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
  default = "my-eks-cluster"
}
variable "cluster-version" {
  description = "Kubernetes version"
  type = string
  default = "1.30"
}
variable "node_group" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type = string
    scaling_config = object({
      desired_size = number
      max_size = number
      min_size = number 
    })
  }))
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        min_size = 1
        max_size = 4
      }
    }
  }
}

variable "instance_class" {
  default = "db.t3.micro"
  description = "value of the instance class"
  type = string
}
variable "db_name" {
  default = "mydb"
  description = "value of the database name"
  type = string
}
variable "db_username" {
  default = "admin"
  description = "value of the database username"
  type = string
}
variable "db_password" {
  default = "password"
  description = "value of the database password"
  type = string
}
variable "db_engine" {
  default = "mysql"
  description = "value of the database engine"
  type = string
}
variable "allocated_storage" {
  default = 20
  description = "value of the allocated storage"
  type = number
}
variable "db_engine_version" {
  default = "8.0"
  description = "value of the database engine version"
  type = string
}
variable "db_identifier" {
  default = "mydb-instance"
  description = "value of the database identifier"
  type = string
}
