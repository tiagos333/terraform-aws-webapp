############## Role to the Addon Application Load Balancer Controller #######################

resource "aws_iam_role" "iam_alb_role" {
      name                  = "alb-assume-role"
      path                  = "/"
      managed_policy_arns   = [aws_iam_policy.iam_alb_policy.arn]
      assume_role_policy    = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Federated": "${var.oidc-eks-arn}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
              "StringEquals": {
                "${replace(var.oidc-eks-url, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
              }
            }
       }]
      })
}

resource "aws_iam_policy" "iam_alb_policy" {
    name        = "alb-policy"
    path        = "/"
    description = "Policy create to be used by the EKS oidc"
    policy      = file(format("${path.module}/alb-policy.json"))
    
}