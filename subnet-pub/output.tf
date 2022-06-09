output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.subnet-pub.id
}
output "nat-gw-id" {
  description = "Nat Gw id"
  value       = aws_nat_gateway.nat_gw.id
}