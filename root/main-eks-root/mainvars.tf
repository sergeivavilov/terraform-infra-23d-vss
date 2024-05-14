#  This is the variables configuration file for the main EKS root module in the root/main-eks-root directory.

### EKS Cluster variables ###

variable "eks_worker_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"  # Description of what the variable is used for.
  type        = string  # Type specification for Terraform, string in this case.
  default     = "eks-worker-role"  # Default value assigned to the variable.
}

variable "eks_name" {
  type    = string  # Type of the variable.
  default = "project-x-dev"  # Default value for the EKS cluster name.
}

variable "eks_version" {
  type    = string  # Indicates the variable stores a string.
  default = "1.29"  # Kubernetes version used for the EKS cluster.
}

variable "eks_vpc_subnet_ids" {
  type    = list(string)  # This variable will hold a list of strings.
  default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Default subnets in us-east-1a and us-east-1b.
}

variable "k8_net_config_cidr" {
  type    = string  # Type of the variable is string.
  default = "10.7.0.0/16"  # CIDR block for Kubernetes networking.
}

variable "tag_name" {
  type    = string  # Type of the variable is string.
  default = "project-x"  # Default tag name for the resources.
}

### Trust Policy variables ###

variable "iam_pol_effect" {
  type    = string  # Data type of the variable.
  default = "Allow"  # Policy effect which typically could be 'Allow' or 'Deny'.
}

variable "iam_pol_prin_type" {
  type    = string  # Data type of the variable.
  default = "Service"  # Principal type for the IAM policy, e.g., 'Service'.
}

variable "iam_pol_prin_identifiers" {
  type    = list(string)  # Data type is a list of strings.
  default = ["eks.amazonaws.com"]  # Default service principal identifier for EKS.
}

variable "iam_pol_actions" {
  type    = list(string)  # Type is a list of strings.
  default = ["sts:AssumeRole"]  # Actions included in the IAM policy.
}

### IAM role variables ###

# Variable for specifying the name of the IAM role for GitHub Actions. This line is commented out.
# variable "iam_role_name" {
#   type = string
#   default = "GitHubActionsTerraformIAMrole"  # Provides the default name of the IAM role for GitHub Actions.
# }

variable "iam_role_name" {
  type    = string  # Specifies the variable type as string.
  default = "project-x-dev-eks-iam-role"  # Default name for the IAM role used in EKS.
}

### IAM role policy attachment variables ###

variable "iam_role_policy_arn" {
  type    = string  # The type of the variable is string.
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # ARN of the policy attached to the IAM role.
}

### EKS Cluster SG variables ###

variable "eks_sg_name" {
  type    = string  # Specifies the variable type as string.
  default = "EKS Cluster Security Group"  # Name of the security group used for the EKS cluster.
}

variable "eks_sg_description" {
  type    = string  # Data type is string.
  default = "Allow All inbound traffic from Self and all outbound traffic"  # Description of the security group's rules.
}

variable "eks_sg_vpc_id" {
  type    = string  # Data type is string.
  default = "vpc-064f95e6b9ba1df03"  # Default VPC ID where the security group will be created.
}

variable "eks_sg_tag" {
  type    = map(string)  # Data type is a map of strings.
  default = {
    Name                            = "eks-cluster-sg"  # Name tag for the security group.
    "kubernetes.io/cluster/project-x-dev" = "owned"  # Kubernetes cluster tag.
    "aws:eks:cluster-name"          = "project-x-dev"  # Tag specifying the name of the EKS cluster.
  }
}

variable "sg_all_port_protocol" {
  type    = string  # Specifies the variable type as string.
  default = "-1"  # This value represents all ports.
}

variable "sg_all_ipv4_traffic" {
  type    = string  # Type of the variable is string.
  default = "0.0.0.0/0"  # Allows all IPv4 traffic.
}

variable "sg_all_ipv6_traffic" {
  type    = string  # Type of the variable is string.
  default = "::/0"  # Allows all IPv6 traffic.
}

variable "sg_allow_tls_port" {
  type    = number  # The data type of this variable is number.
  default = 443  # Default port number for TLS/SSL traffic.
}

### WORKERS variables ###

variable "worker_lt_name_prefix" {
  type    = string  # Type of the variable is string.
  default = "project-x-eks-dev-worker-nodes"  # Default name prefix for EKS worker nodes.
}

variable "worker_lt_inst_type" {
  type    = string  # Specifies the variable type as string.
  default = "t3.medium"  # Default instance type for the worker nodes.
}

### Worker ASG variables ###

variable "worker_asg_desired_cap" {
  type    = number  # Data type is number.
  default = 2  # Desired capacity of the Auto Scaling Group.
}

variable "worker_asg_max_size" {
  type    = number  # Type of the variable is number.
  default = 3  # Maximum size of the Auto Scaling Group.
}

variable "worker_asg_min_size" {
  type    = number  # Data type is number.
  default = 1  # Minimum size of the Auto Scaling Group.
}

### Worker ASG mixed instance policy variables ###

variable "worker_asg_base_cap" {
  type    = number  # Specifies the variable type as number.
  default = 0  # Base capacity of on-demand instances.
}

variable "worker_asg_percent_base_cap" {
  type    = number  # Type of the variable is number.
  default = 0  # Percentage of additional capacity above the base on-demand capacity.
}

variable "worker_asg_spot_strategy" {
  type    = string  # Data type is string.
  default = "capacity-optimized"  # Spot allocation strategy to optimize for capacity.
}

### Worker ASG launch template variables ###

variable "override_inst_type_1" {
  type    = string  # Type of the variable is string.
  default = "t3.medium"  # First instance type override in the launch template.
}

variable "override_weight_cap_1" {
  type    = string  # Specifies the variable type as string.
  default = "2"  # Weighted capacity for the first override instance type.
}

variable "override_inst_type_2" {
  type    = string  # Type of the variable is string.
  default = "t2.medium"  # Second instance type override in the launch template.
}

variable "override_weight_cap_2" {
  type    = string  # Specifies the variable type as string.
  default = "2"  # Weighted capacity for the second override instance type.
}

variable "rds_master_username" {
  description = "The master username for the RDS instance"  # Description of the variable.
  type        = string  # Type of the variable is string.
}

variable "rds_master_password" {
  description = "The master password for the RDS instance"  # Description of the variable.
  type        = string  # Data type is string.
  sensitive   = true  # Marks the variable as sensitive, which means it will not be logged or outputted in plaintext.
}
