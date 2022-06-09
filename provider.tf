
terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
  backend "s3" {
    bucket         = "remote-terraform-st"
    key            = "tf.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubernetes" {
  host                   = module.eks-cluster.eks-cluster-endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.eks-cluster-ca-cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", module.eks-cluster.eks-cluster-name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks-cluster.eks-cluster-endpoint
    cluster_ca_certificate = base64decode(module.eks-cluster.eks-cluster-ca-cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eks-cluster.eks-cluster-name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.eks-cluster.eks-cluster-endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.eks-cluster-ca-cert)
  load_config_file       = false

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eks-cluster.eks-cluster-name]
      command     = "aws"
    }
}