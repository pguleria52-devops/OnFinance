output "vpc_id" {
  value = aws_vpc.vpc.id
  
}

output "public_subnet" {
  value = aws_subnet.public[*].id
  description = "Public subnets"
}
output "private_subnet" {
  value = aws_subnet.private[*].id
}
# output "security_group_ids" {
#   value = aws_security_group.this.id
# }

# output "db_subnet_group_name" {
#   value = aws_db_subnet_group.this.name
# }

