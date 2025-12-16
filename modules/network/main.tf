
# Application VPC
resource "aws_vpc" "application_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, {
    Name = "application-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.application_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = merge(var.tags, {
    Name = "public-subnet"
  })
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.application_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = merge(var.tags, {
    Name = "private-subnet"
  })
}

# Internet access to vpc
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.application_vpc.id
  tags   = var.tags
}

resource "aws_route_table" "application_vpc_route_table" {
  vpc_id = aws_vpc.application_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  tags = merge(var.tags, {
    Name = "application-vpc-route-table"
  })
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.application_vpc_route_table.id
}

resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.application_vpc_route_table.id
}

# Firewall rules
resource "aws_security_group" "immich_sg" {
  name        = "immich-sg"
  description = "Allow SSH and Immich web access"
  tags = merge(var.tags, {
    Name = "immich-sg"
  })

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.firewall_ssh_cidr
  }

  ingress {
    description = "Immich Web UI"
    from_port   = 2283 # immich port
    to_port     = 2283
    protocol    = "tcp"
    cidr_blocks = var.firewall_usr_cidr
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}