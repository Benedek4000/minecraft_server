resource "aws_vpc" "vpc" {
  cidr_block = "10.${var.vpc_number}.0.0/16"
  tags = {
    Name = "${var.project}-${var.server_name}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${var.az}"
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = local.cidrBlocks.cidrAnyone[0]
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
