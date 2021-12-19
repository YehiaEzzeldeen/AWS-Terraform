provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  tags = {
    Name = "${customer_name}-${account_name}-VPC-01"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${customer_name}-${account_name}-IGW-01"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
  for_each   = var.public_subnets
  count      = length(var.public_subnets_names)
  tags = {
    Name = var.public_subnets_names[count.index]
  }
}

