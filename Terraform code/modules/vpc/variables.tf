variable "cidr" {
  type = string
  description = "value of cidr block"
}
variable "public_subnet" {
  type = list(string)
  description = "value of public subnet"
  
}
variable "private_subnet" {
  type = list(string)
  description = "value of private subnet"
  
}
variable "availability_zone" {
  type = list(string)
  description = "value of availability zone"
  
}
variable "cluster_name" {
  type = string
  description = "value of cluster name"
  
}