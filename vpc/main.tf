resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
    tags = var.vpc-tags
}
resource "aws_internet_gateway" "gw" {
  depends_on = [aws_vpc.vpc]
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table_public" {
  depends_on = [aws_vpc.vpc]
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "route_public" {
  depends_on = [aws_route_table.route_table_public, aws_internet_gateway.gw]
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.gw.id
}
