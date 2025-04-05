variable "region" {
  description = "AWS region"
  type        = string
}

variable "db_identifier" {
  description = "Unique name for the DB instance"
  type        = string
}

variable "db_engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "Instance type for RDS"
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
}

variable "storage_type" {
  description = "Type of storage (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "db_username" {
  description = "Master database username"
  type        = string
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs assigned to the DB instance"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Subnet group name for the DB instance"
  type        = string
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before deletion"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
  default     = {}
}