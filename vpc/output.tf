output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.vpc.id
}
output "route_public" {
  description = "route to the internet"
  value       = aws_route_table.route_table_public.id
}