# Providers.tf
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "githubactions-terraform-task"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}


provider "kubernetes" {
  host                   = module.project-x-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(module.project-x-eks-cluster.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.cluster.token

  load_config_file = false
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_name
}
