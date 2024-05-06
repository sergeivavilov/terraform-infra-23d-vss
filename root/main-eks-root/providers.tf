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
