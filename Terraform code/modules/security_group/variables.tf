variable "region" {
  description = "AWS region"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type        = list(map(string))
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to create"
  type        = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))  # This should be list(string), not string
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  
  # Default egress rule to allow all outbound traffic
  default     = [{
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
  default     = "OnFinance"
  
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
  
}