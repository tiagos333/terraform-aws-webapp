resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = var.eks-cluster-name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks-node-role.arn
  instance_types  = var.node-instance-type

  subnet_ids      = var.nodegroup_subnet_ids

  scaling_config {
    desired_size = var.worknode_desired_size
    max_size     = var.worknode_max_size
    min_size     = var.worknode_min_size
  }
  ami_type   = var.ami_type
  tags       = var.nodegroup-tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}