output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.RDS.id
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.RDS.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.RDS.db_name
}
