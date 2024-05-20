# Providers.tf - Configuration file specifying providers and their settings.


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












# # Configure the AWS provider.
# provider "aws" {
#   region = "us-east-1"  # AWS region where the resources will be managed.
# }

# # Terraform state backend configuration.
# terraform {
#   backend "s3" {
#     bucket  = "githubactions-terraform-task"  # S3 bucket name for storing Terraform state files.
#     key     = "terraform.tfstate"  # Path to the state file within the S3 bucket.
#     region  = "us-east-1"  # AWS region where the S3 bucket is located.
#     encrypt = true  # Enables encryption at rest for the state file stored in S3.
#   }
# }

# # Configure the Kubernetes provider.
# provider "kubernetes" {
#   host                   = module.project-x-eks-cluster.endpoint  # The API server URL, fetched from the EKS cluster module.
#   cluster_ca_certificate = base64decode(module.project-x-eks-cluster.kubeconfig-certificate-authority-data)  # CA certificate used to authenticate with the Kubernetes cluster, decoded.
#   token                  = data.aws_eks_cluster_auth.cluster.token  # Token used for authentication with the Kubernetes cluster.
# }

# # Fetch authentication data for an AWS EKS cluster.
# data "aws_eks_cluster_auth" "cluster" {
#   name = var.eks_name  # Name of the EKS cluster for which to fetch authentication data.
# }
