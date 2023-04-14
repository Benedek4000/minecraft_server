resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${var.az}"
  cidr_block        = cidrsubnet(var.cidr_vpc, 8, 1)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_anyone
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "server" {
  name   = "${var.project}-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "ssh access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anyone] # maybe fix this
  }
  egress {
    description = "http access"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anyone]
  }
  egress {
    description = "https access"
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anyone]
  }
  ingress {
    description = "server in"
    from_port   = var.port_server
    to_port     = var.port_server
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anyone]
  }
  ingress {
    description = "RCON"
    from_port   = var.port_rcon
    to_port     = var.port_rcon
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anyone]
  }
}
