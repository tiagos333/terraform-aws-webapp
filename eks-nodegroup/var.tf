variable "eks-cluster-name" {
  type = string
}
variable "node_group_name" {
  type = string
}
variable "node-instance-type" {
  type = list
}
variable "nodegroup_subnet_ids" {
  type = list
}
variable "worknode_desired_size" {
  type = string
}
variable "worknode_max_size" {
  type = string
}
variable "worknode_min_size" {
  type = string
}
variable "nodegroup-tags" {
  type = map
}
variable "ami_type" {
  type = string
}