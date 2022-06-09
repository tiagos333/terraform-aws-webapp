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
variable "destination_cidr" {
  type = string
}
variable "nat-gw-id" {
  type = string
}