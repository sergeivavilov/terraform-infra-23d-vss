eks_name = "project-x-dev"
eks_version = "1.29"
eks_vpc_subnet_ids = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Subnets in us-east-1a and us-east-1b
k8_net_config_cidr = "10.7.0.0/16"
tag_name = "project-x" 
iam_pol_effect = "Allow"
iam_pol_prin_type = "Service"
iam_pol_prin_identifiers = ["eks.amazonaws.com"]
iam_pol_actions = ["sts:AssumeRole"]
#########
iam_role_name = "GitHubActionsTerraformIAMrole"  # Name of the IAM role for GitHub Actions
#iam_role_name = "project-x-dev-eks-iam-role"  #that was before- not sure yet
#########
iam_role_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
eks_sg_name = "EKS Cluster Security Group"
eks_sg_description = "Allow All inbound traffic from Self and all outbound traffic"
eks_sg_vpc_id = "vpc-064f95e6b9ba1df03"  # default VPC ID
eks_sg_tag = {
    Name = "eks-cluster-sg"
    "kubernetes.io/cluster/project-x-dev" = "owned"
    "aws:eks:cluster-name"	= "project-x-dev"
  }
sg_all_port_protocol = "-1" # semantically equivalent to all ports
sg_all_ipv4_traffic = "0.0.0.0/0"
sg_all_ipv6_traffic = "::/0"
sg_allow_tls_port = 0
worker_lt_name_prefix = "project-x-eks-dev-worker-nodes"
worker_lt_inst_type = "t3.medium"
worker_asg_desired_cap = 2
worker_asg_max_size = 3
worker_asg_min_size = 1
worker_asg_base_cap = 0
worker_asg_percent_base_cap = 0
worker_asg_spot_strategy = "capacity-optimized"
override_inst_type_1 = "t3.medium"
override_weight_cap_1 = "2"
override_inst_type_2 = "t2.medium"
override_weight_cap_2 = "2"