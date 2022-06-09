resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.eks-version

  tags = var.eks-tags

  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}

data "tls_certificate" "tls_eks" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc-eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls_eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}