# RDS Configuration
rds_master_username = "admin"  # Username for the RDS master user.
rds_master_password = "password"  # Password for the RDS master user. Ensure this is managed securely.

# EKS Configuration
eks_name = "project-x-dev"  # Name of the EKS cluster.
eks_version = "1.29"  # Version of EKS.
eks_vpc_subnet_ids = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # List of subnet IDs in us-east-1a and us-east-1b for the EKS cluster.
k8_net_config_cidr = "10.7.0.0/16"  # CIDR block for Kubernetes networking.
tag_name = "project-x"  # Tag name applied to all resources.

# IAM Role Configuration
iam_pol_effect = "Allow"  # IAM policy effect.
iam_pol_prin_type = "Service"  # Type of IAM principal.
iam_pol_prin_identifiers = ["eks.amazonaws.com"]  # Service principal for the IAM role.
iam_pol_actions = ["sts:AssumeRole"]  # Actions allowed by the IAM policy.

# IAM Role Name (choose one based on the use case)
iam_role_name = "GitHubActionsTerraformIAMrole"  # Name of the IAM role for GitHub Actions.
# iam_role_name = "project-x-dev-eks-iam-role"  # Alternate name for the IAM role.

# IAM Role Policy
iam_role_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # ARN of the IAM policy attached to the role.

# Security Group Configuration for EKS
eks_sg_name = "EKS Cluster Security Group"  # Name of the EKS cluster security group.
eks_sg_description = "Allow All inbound traffic from Self and all outbound traffic"  # Description of the security group.
eks_sg_vpc_id = "vpc-064f95e6b9ba1df03"  # VPC ID where the security group is defined.

# Tags for the EKS Security Group
eks_sg_tag = {
    Name = "eks-cluster-sg"
    "kubernetes.io/cluster/project-x-dev" = "owned"
    "aws:eks:cluster-name" = "project-x-dev"
  }  # Tags assigned to the EKS security group.

# Security Group Traffic Configuration
sg_all_port_protocol = "-1"  # Allows all types of traffic.
sg_all_ipv4_traffic = "0.0.0.0/0"  # Allows all IPv4 traffic.
sg_all_ipv6_traffic = "::/0"  # Allows all IPv6 traffic.
sg_allow_tls_port = 443  # Specifies the TLS port (HTTPS).

# Worker Node Configuration
worker_lt_name_prefix = "project-x-eks-dev-worker-nodes"  # Prefix for worker node names.
worker_lt_inst_type = "t3.medium"  # Instance type for the worker nodes.
worker_asg_desired_cap = 2  # Desired capacity of the Auto Scaling group.
worker_asg_max_size = 3  # Maximum size of the Auto Scaling group.
worker_asg_min_size = 1  # Minimum size of the Auto Scaling group.

# Worker ASG Mixed Instance Policy Configuration
worker_asg_base_cap = 0  # Base capacity for on-demand instances.
worker_asg_percent_base_cap = 0  # Percentage of additional capacity above the base on-demand capacity.
worker_asg_spot_strategy = "capacity-optimized"  # Spot allocation strategy for the Auto Scaling group.

# Worker ASG Launch Template Overrides
override_inst_type_1 = "t3.medium"  # First override instance type.
override_weight_cap_1 = "2"  # Weighted capacity for the first override.
override_inst_type_2 = "t2.medium"  # Second override instance type.
override_weight_cap_2 = "2"  # Weighted capacity for the second override.
