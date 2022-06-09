#variable "region" {
#  type = string
#}
variable "vpc-id" {
  type = string
}
variable "cidr-ip" {
  type = string
}

variable "zone" {
  type = string
}
variable "tags" {
  type = map
}
variable "route_public" {
  type = string
}
variable "elastic-ip" {
  type = string
}