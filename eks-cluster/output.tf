output "eks-cluster-name" {
  description = "elastic-IP"
  value       = aws_eks_cluster.eks-cluster.name
}
output "eks-cluster-endpoint" {
  description = "EkS Endpoint"
  value       = aws_eks_cluster.eks-cluster.endpoint
}
output "eks-cluster-ca-cert" {
  description = "EKS Certificate CA"
  value       = aws_eks_cluster.eks-cluster.certificate_authority.0.data
}
output "eks-cluster-id" {
  description = "cluster-id"
  value       = aws_eks_cluster.eks-cluster.id
}
output "oidc-eks-arn" {
  description = "cluster-id"
  value       = aws_iam_openid_connect_provider.oidc-eks.arn
}
output "oidc-eks-url" {
  description = "cluster-id"
  value       = aws_iam_openid_connect_provider.oidc-eks.url
}