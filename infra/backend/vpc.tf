# Define a vpc
resource "aws_vpc" "vpc" {
  cidr_block = "10.5.0.0/16"
  tags = {
    Name      = "${var.prefix}"
    createdBy = "infra-${var.prefix}/backend"
  }
}

resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.prefix}/backend/vpc_id"
  value = aws_vpc.vpc.id
  type  = "String"
}

# Routing table for public subnets
resource "aws_route_table" "public_subnet_routes" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name      = "Public subnet routing table"
    createdBy = "infra-${var.prefix}/backend"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "Public gateway"
    createdBy = "infra-${var.prefix}/backend"
  }
}

# NAT Gateway for private subnet
resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "gw NAT"
  }
}

#public subnets

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.5.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name      = "Public subnet A"
    createdBy = "infra-${var.prefix}/backend"
  }
}

resource "aws_ssm_parameter" "public_subnet_a" {
  name  = "/${var.prefix}/backend/public_subnet/a/id"
  value = aws_subnet.public_subnet_a.id
  type  = "String"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.5.1.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name      = "Public subnet B"
    createdBy = "infra-${var.prefix}/backend"
  }
}

resource "aws_ssm_parameter" "public_subnet_b" {
  name  = "/${var.prefix}/backend/public_subnet/b/id"
  value = aws_subnet.public_subnet_b.id
  type  = "String"
}


resource "aws_route_table_association" "public_subnet_routes_assn_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_subnet_routes.id
}

resource "aws_route_table_association" "public_subnet_routes_assn_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_subnet_routes.id
}


#private subnets

resource "aws_route_table" "nat_gw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.5.10.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name      = "private subnet A"
    createdBy = "infra-${var.prefix}/backend"
  }
}

resource "aws_ssm_parameter" "private_subnet_a" {
  name  = "/${var.prefix}/backend/private_subnet/a/id"
  value = aws_subnet.private_subnet_a.id
  type  = "String"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.5.11.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name      = "private subnet B"
    createdBy = "infra-${var.prefix}/backend"
  }
}

resource "aws_ssm_parameter" "private_subnet_b" {
  name  = "/${var.prefix}/backend/private_subnet/b/id"
  value = aws_subnet.private_subnet_b.id
  type  = "String"
}

# Here, you can add more subnets in other availability zones

# Associate the routing table to private subnet A
resource "aws_route_table_association" "private_subnet_routes_assn_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.nat_gw.id
}

# Associate the routing table to private subnet B
resource "aws_route_table_association" "private_subnet_routes_assn_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.nat_gw.id
}
