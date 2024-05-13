# this is : terraform-infra-23d-vss/eks-module/variables.tf


### EKS Cluster variables ###

#configmap
variable "eks_worker_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
  default     = "eks-worker-role"
}

### EKS Cluster variables ###


variable "eks_name" {
  type = string
  default = "project-x-dev"
}

variable "eks_version" {
  type = string
  default = "1.29"
}

variable "eks_vpc_subnet_ids" {
  type = list(string)
  default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Subnets in us-east-1a and us-east-1b
}

variable "k8_net_config_cidr" {
  type = string
  default = "10.7.0.0/16"
}

variable "tag_name" {
  type = string
  default = "project-x"  
}

### Trust Policy variables ###

variable "iam_pol_effect" {
  type = string
  default = "Allow"
}

variable "iam_pol_prin_type" {
  type = string
  default = "Service"
}

variable "iam_pol_prin_identifiers" {
  type = list(string)
  default = ["eks.amazonaws.com"]
}

variable "iam_pol_actions" {
  type = list(string)
  default = ["sts:AssumeRole"]
}

### IAM role variables ###

variable "iam_role_name" {
  type = string
  default = "project-x-dev-eks-iam-role"
}

### IAM role policy attachment variables ###

variable "iam_role_policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

### EKS Cluster SG variables ###

variable "eks_sg_name" {
  type = string
  default = "EKS Cluster Security Group"
}

variable "eks_sg_description" {
  type = string
  default = "Allow All inbound traffic from Self and all outbound traffic"
}

variable "eks_sg_vpc_id" {
  type = string
  default = "vpc-064f95e6b9ba1df03"  # default VPC ID
}

variable "eks_sg_tag" {
  type = map(string)
  default = {
    Name = "eks-cluster-sg"
    "kubernetes.io/cluster/project-x-dev" = "owned"
    "aws:eks:cluster-name"	= "project-x-dev"
  }
}

variable "sg_all_port_protocol" {
  type = string
  default = "-1" # semantically equivalent to all ports
}

variable "sg_all_ipv4_traffic" {
  type = string
  default = "0.0.0.0/0"
}

variable "sg_all_ipv6_traffic" {
  type = string
  default = "::/0"
}

variable "sg_allow_tls_port" {
  type = number
  default = 443 
}

### WORKERS variables ###

variable "worker_lt_name_prefix" {
  type = string
  default = "project-x-eks-dev-worker-nodes"
}

variable "worker_lt_inst_type" {
  type = string
  default = "t3.medium"
}

### Worker ASG variables ###

variable "worker_asg_desired_cap" {
  type = number
  default = 2
}

variable "worker_asg_max_size" {
  type = number
  default = 3
}

variable "worker_asg_min_size" {
  type = number
  default = 1
}

### Worker ASG mixed instance policy variables ###

variable "worker_asg_base_cap" {
  type = number
  default = 0
}

variable "worker_asg_percent_base_cap" {
  type = number
  default = 0
}

variable "worker_asg_spot_strategy" {
  type = string
  default = "capacity-optimized"
}

### Worker ASG launch template variables ###

variable "override_inst_type_1" {
  type = string
  default = "t3.medium"
}

variable "override_weight_cap_1" {
  type = string
  default = "2"
}

variable "override_inst_type_2" {
  type = string
  default = "t2.medium"
}

variable "override_weight_cap_2" {
  type = string
  default = "2"
}
