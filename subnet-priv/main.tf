
resource "aws_subnet" "subnet-priv" {
  vpc_id                          = var.vpc-id
  cidr_block                      = var.cidr-ip
  availability_zone               = var.zone
  tags                            = var.tags
}

resource "aws_eip" "elastic" {
  vpc        = true
}

resource "aws_route_table" "route_table_private" {
  vpc_id = var.vpc-id
}

resource "aws_route" "route_private" {
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = var.nat-gw-id
}

resource "aws_route_table_association" "aws_route_table_association" {
  subnet_id      = aws_subnet.subnet-priv.id
  route_table_id = aws_route_table.route_table_private.id
}