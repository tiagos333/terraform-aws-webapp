###################### Creating Service Account for the ALB Controller ##############

resource "kubernetes_service_account_v1" "aws-load-balancer-controller" {
  metadata {
    labels = {
      "app.kubernetes.io/component" : "controller"
      "app.kubernetes.io/name" : "aws-load-balancer-controller"
    }
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
        "eks.amazonaws.com/role-arn" : aws_iam_role.iam_alb_role.arn
    }
  }
}
###################### Installing the ALB controller using the Helm 3.0 #####################


resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system" 
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
 
  set {
    name  = "clusterName"
    value = var.eks-cluster-name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}