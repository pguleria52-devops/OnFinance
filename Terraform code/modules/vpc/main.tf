resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  enable_dns_support = true
  enable_dns_hostnames = true
    tags = {
        Name = "${var.cluster_name}-vpc"
    }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "${var.cluster_name}-private-${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.availability_zone, count.index)
  cidr_block = element(var.public_subnet, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-${count.index+1}"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}
resource "aws_eip" "elasticIP" {
  count = length(var.public_subnet)
  domain = "vpc"
  tags = {
    Name = "${var.cluster_name}-EIP-${count.index+1}"
  }
}

resource "aws_nat_gateway" "name" {
  count = length(var.private_subnet)
  allocation_id = aws_eip.elasticIP[count.index].id
  # subnet_id = aws_subnet.private[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.cluster_name}-NAT-${count.index+1}"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public_route"
  }
}



resource "aws_route_table_association" "public-association" {
  route_table_id = aws_route_table.public-route.id
  count = length(var.public_subnet)
  subnet_id = aws_subnet.public[count.index].id
}


resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.private_subnet)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}-private-route-${count.index+1}"
  }
}

resource "aws_route_table_association" "private-association" {
  count = length(var.private_subnet)
  route_table_id = aws_route_table.private-route[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}