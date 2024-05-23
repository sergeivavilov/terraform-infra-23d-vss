# Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "githubactions-terraform-task"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# this provider required for configmap creation
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  host                   = module.project-x-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(module.project-x-eks-cluster.kubeconfig-certificate-authority-data[0].data)
}
