output "security_group_id" {
  description = "ID of the created security group"
  value       = [aws_security_group.this.id]
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.this.name
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.OnFinance.name
  
}