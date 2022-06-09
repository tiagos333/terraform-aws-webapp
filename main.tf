############################### VPC Module #######################
module "vpc" {
  source            = "./vpc"
  cidr_block        = "10.0.0.0/16"
  destination_cidr  = "0.0.0.0/0"
  vpc-tags          = {
    Name = "VPC-APP"
  }

}

############################## Subnet Public Module ####################
module "subnet-pub-a" {
  depends_on = [module.vpc]
  source            = "./subnet-pub"
  vpc-id            = module.vpc.vpc_id
  route_public      = module.vpc.route_public
  zone              = "eu-west-2a"
  cidr-ip           = "10.0.0.0/24"
  elastic-ip        = module.subnet-priv-a.elastic-ip
  tags              = {
    "Name" = "public-subnet-a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-app" = "shared"
    }
}

module "subnet-pub-b" {
  depends_on = [module.vpc]
  source            = "./subnet-pub"
  vpc-id            = module.vpc.vpc_id
  route_public      = module.vpc.route_public
  zone              = "eu-west-2b"
  cidr-ip           = "10.0.1.0/24"
  elastic-ip        = module.subnet-priv-b.elastic-ip
  tags              = {
    "Name" = "public-subnet-b"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-app" = "shared"
    }
}

############################## Subnet Private Module ####################

module "subnet-priv-a" {
  depends_on = [module.vpc]
  source            = "./subnet-priv"
  vpc-id            = module.vpc.vpc_id
  zone              = "eu-west-2a"
  cidr-ip           = "10.0.2.0/24"
  destination_cidr  = "0.0.0.0/0"
  nat-gw-id         = module.subnet-pub-a.nat-gw-id
  tags              = {
    "Name" = "private-subnet-a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks-app" = "shared"
    }
}
module "subnet-priv-b" {
  depends_on = [module.vpc]
  source            = "./subnet-priv"
  vpc-id            = module.vpc.vpc_id
  zone              = "eu-west-2b"
  cidr-ip           = "10.0.3.0/24"
  destination_cidr  = "0.0.0.0/0"
  nat-gw-id         = module.subnet-pub-a.nat-gw-id
  tags              = {
    "Name" = "private-subnet-b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks-app" = "shared"
    }
}

############################## Eks Cluster Module ####################

module "eks-cluster" {
  depends_on = [module.vpc, module.subnet-pub-a, module.subnet-pub-b, module.subnet-priv-a, module.subnet-priv-a]
  source           = "./eks-cluster"
  eks_name         = "eks-app"
  eks-version      = "1.21"
  eks_subnet_ids   = flatten([module.subnet-pub-a.subnet_id, module.subnet-pub-b.subnet_id, module.subnet-priv-a.subnet_id, module.subnet-priv-b.subnet_id])
  eks-tags         = {
    Name = "shared"
  }
  
}

############################## Eks Main Node Group ####################

module "eks-nodegroup" {
  depends_on = [module.eks-cluster]
  source                = "./eks-nodegroup"
  eks-cluster-name      = module.eks-cluster.eks-cluster-name
  node_group_name       = "main-group"
  node-instance-type    = ["t3.medium"]
  ami_type              = "AL2_x86_64"
  nodegroup_subnet_ids  = flatten([module.subnet-priv-a.subnet_id, module.subnet-priv-b.subnet_id])
  worknode_desired_size = "2"
  worknode_max_size     = "4"
  worknode_min_size     = "2"
  nodegroup-tags        = {
    Name = "shared"
  }

}

################################ EKS Addons ###########################

module "eks-addons" {
  depends_on = [module.eks-nodegroup]
  source                = "./eks-addons"
  oidc-eks-arn          = module.eks-cluster.oidc-eks-arn
  oidc-eks-url          = module.eks-cluster.oidc-eks-url
  eks-cluster-name      = module.eks-cluster.eks-cluster-name
}

############################## Install Application ####################


data "kubectl_path_documents" "manifests" {
  pattern = "./manifests/*.yaml"
}

resource "kubectl_manifest" "web-app" {
  depends_on = [module.eks-nodegroup]
  for_each  = toset(data.kubectl_path_documents.manifests.documents)
  yaml_body = each.value
}