

########################################## Subnetwork #########################
resource "aws_subnet" "subnet-pub" {
  vpc_id                          = var.vpc-id
  cidr_block                      = var.cidr-ip
  availability_zone               = var.zone
  tags                            = var.tags
  map_public_ip_on_launch         = true
}


resource "aws_route_table_association" "aws_route_table_association" {
  subnet_id      = aws_subnet.subnet-pub.id
  route_table_id = var.route_public
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = var.elastic-ip
  subnet_id     = aws_subnet.subnet-pub.id

}