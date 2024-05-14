# File identifier and location within the project structure.
# this is : terraform-infra-23d-vss/eks-module/variables.tf

### EKS Cluster variables ###

# Defines the IAM role name for EKS worker nodes.
variable "eks_worker_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
  default     = "eks-worker-role"
}

# Defines the name of the EKS cluster.
variable "eks_name" {
  type    = string
  default = "project-x-dev"
}

# Defines the version of the EKS cluster.
variable "eks_version" {
  type    = string
  default = "1.29"
}

# List of subnet IDs for the EKS cluster.
variable "eks_vpc_subnet_ids" {
  type    = list(string)
  default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Subnets in us-east-1a and us-east-1b
}

# CIDR block for the Kubernetes network configuration.
variable "k8_net_config_cidr" {
  type    = string
  default = "10.7.0.0/16"
}

# Defines a tag for resources associated with the EKS cluster.
variable "tag_name" {
  type    = string
  default = "project-x"
}

### Trust Policy variables ###

# Permission effect for the IAM role's trust policy.
variable "iam_pol_effect" {
  type    = string
  default = "Allow"
}

# The type of principal that can assume the IAM role.
variable "iam_pol_prin_type" {
  type    = string
  default = "Service"
}

# Identifiers for the principal that can assume the IAM role.
variable "iam_pol_prin_identifiers" {
  type    = list(string)
  default = ["eks.amazonaws.com"]
}

# Actions allowed by the trust policy.
variable "iam_pol_actions" {
  type    = list(string)
  default = ["sts:AssumeRole"]
}

### IAM role variables ###

# Commented out: Previous default value for an IAM role name.
# variable "iam_role_name" {
#   type    = string
#   default = "GitHubActionsTerraformIAMrole"  # Name of the IAM role for GitHub Actions
# }

# Defines the name for the IAM role associated with the EKS cluster.
variable "iam_role_name" {
  type    = string
  default = "project-x-dev-eks-iam-role"
}

### IAM role policy attachment variables ###

# ARN of the policy attached to the IAM role.
variable "iam_role_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

### EKS Cluster SG variables ###

# Name of the security group associated with the EKS cluster.
variable "eks_sg_name" {
  type    = string
  default = "EKS Cluster Security Group"
}

# Description of the EKS cluster security group.
variable "eks_sg_description" {
  type    = string
  default = "Allow All inbound traffic from Self and all outbound traffic"
}

# VPC ID where the security group is to be created.
variable "eks_sg_vpc_id" {
  type    = string
  default = "vpc-064f95e6b9ba1df03"  # default VPC ID
}

# Tags attached to the EKS cluster security group.
variable "eks_sg_tag" {
  type    = map(string)
  default = {
    Name                            = "eks-cluster-sg"
    "kubernetes.io/cluster/project-x-dev" = "owned"
    "aws:eks:cluster-name"          = "project-x-dev"
  }
}

# Protocol used for the security group, allowing all ports.
variable "sg_all_port_protocol" {
  type    = string
  default = "-1"  # semantically equivalent to all ports
}

# Allows all IPv4 traffic within the security group.
variable "sg_all_ipv4_traffic" {
  type    = string
  default = "0.0.0.0/0"
}

# Allows all IPv6 traffic within the security group.
variable "sg_all_ipv6_traffic" {
  type    = string
  default = "::/0"
}

# TLS port allowed in the security group.
variable "sg_allow_tls_port" {
  type    = number
  default = 443
}

### WORKERS variables ###

# Prefix for the name of the launch templates for worker nodes.
variable "worker_lt_name_prefix" {
  type    = string
  default = "project-x-eks-dev-worker-nodes"
}

# Instance type for the worker nodes.
variable "worker_lt_inst_type" {
  type    = string
  default = "t3.medium"
}

### Worker ASG variables ###

# Desired capacity of the Auto Scaling Group for worker nodes.
variable "worker_asg_desired_cap" {
  type    = number
  default = 2
}

# Maximum size of the Auto Scaling Group for worker nodes.
variable "worker_asg_max_size" {
  type    = number
  default = 3
}

# Minimum size of the Auto Scaling Group for worker nodes.
variable "worker_asg_min_size" {
  type    = number
  default = 1
}

### Worker ASG mixed instance policy variables ###

# Base capacity for on-demand instances in the Auto Scaling Group.
variable "worker_asg_base_cap" {
  type    = number
  default = 0
}

# Percentage of additional capacity above the base for on-demand instances.
variable "worker_asg_percent_base_cap" {
  type    = number
  default = 0
}

# Spot allocation strategy for the Auto Scaling Group.
variable "worker_asg_spot_strategy" {
  type    = string
  default = "capacity-optimized"
}

### Worker ASG launch template variables ###

# First override instance type in the launch template.
variable "override_inst_type_1" {
  type    = string
  default = "t3.medium"
}

# Weighted capacity for the first override instance type.
variable "override_weight_cap_1" {
  type    = string
  default = "2"
}

# Second override instance type in the launch template.
variable "override_inst_type_2" {
  type    = string
  default = "t2.medium"
}

# Weighted capacity for the second override instance type.
variable "override_weight_cap_2" {
  type    = string
  default = "2"
}

### RDS variables ###

# Master username for the RDS instance.
variable "rds_master_username" {
  description = "The master username for the RDS instance"
  type        = string
}

# Master password for the RDS instance, marked as sensitive.
variable "rds_master_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}
