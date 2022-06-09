output "elastic-ip" {
  description = "elastic-IP"
  value       = aws_eip.elastic.id
}
output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.subnet-priv.id
}