# output "cluster-endpoints" {
#   description = "values of the cluster endpoints"
#   value = module.eks.cluster_endpoints
# }

# output "cluster-name" {
#   description = "Name of the EKS cluster"
#   value = module.eks.cluster_name
# }

# output "vpc_id" {
#   description = "value of the VPC ID"
#   value = module.vpc.vpc_id
# }
# output "security_group_ids" {
#   value = aws_security_group.security_group[*].id
#   description = "Security group IDs"
# }
# output "cluster_security_group_id" {
#   value = module.eks.cluster_security_group_id
#   description = "Cluster security group ID"
# }
# output "cluster_security_group_name" {
#   value = module.eks.cluster_security_group_name
#   description = "Cluster security group name"
# }
# output "cluster_security_group_arn" {
#   value = module.eks.cluster_security_group_arn
#   description = "Cluster security group ARN"
# }
