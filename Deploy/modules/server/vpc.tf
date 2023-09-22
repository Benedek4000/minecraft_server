resource "aws_subnet" "public" {
  vpc_id            = var.vpc.id
  availability_zone = "${var.region}${var.az}"
  cidr_block        = cidrsubnet(var.vpc.cidr_block, 8, var.subnet_number)
  tags = {
    Name = "${var.project}-${var.server_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc.id
  route {
    cidr_block = local.cidrBlocks.cidrAnyone[0]
    gateway_id = var.ig.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
