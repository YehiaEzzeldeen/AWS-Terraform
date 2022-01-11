provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  tags = {
    Name = "${var.customer_name}-${var.account_name}-VPC-01"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.customer_name}-${var.account_name}-IGW-01"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  count      = length(var.public_subnets)
  tags = {
    Name = "${var.public_subnets_names[count.index]}"
  }
}

resource "aws_eip" "ngwEIP" {
  vpc = true
  tags = {
    Name = "ngwEIP"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngwEIP.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = "NGW"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public Route Table"
  }
}

resource "aws_route_table_association" "pub_rt_assoc" {
  subnet_id      = aws_subnet.public_subnets[count.index].id
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets[count.index]
  count      = length(var.private_subnets)
  tags = {
    Name = "${var.private_subnets_names[count.index]}"
  }
}

resource "aws_route_table" "prv_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "prv_rt_assoc" {
  subnet_id      = aws_subnet.private_subnets[count.index].id
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.prv_rt.id
}

####################### SG

resource "aws_security_group" "SGs" {
  name        = var.security_groups_names[count.index]
  count          = length(var.security_groups_names)
  description = var.security_groups_names[count.index]
  vpc_id      = aws_vpc.vpc.id
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.security_groups_names[count.index]
  }
}


output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "private-subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "security-groups" {
  value = aws_security_group.SGs[*].id
}
