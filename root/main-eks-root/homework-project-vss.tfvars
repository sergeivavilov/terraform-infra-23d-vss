##### EKS Cluster #####

cluster_name       = "project-x-dev"
cluster_version    = "1.29"
cluster_subnet_ids = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
cluster_cidr       = "10.7.0.0/16"

cluster_tag = "project-x"

##### Trust policy #####

policy_effect      = "Allow"
policy_type        = "Service"
policy_identifiers = ["eks.amazonaws.com"]
policy_actions     = ["sts:AssumeRole"]

##### IAM Role #####

role_name = "project-x-dev-eks-iam-role"

##### Role policy attachment #####

attachment_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

##### EKS Cluster sg #####

eks_cluster_sg_name        = "EKS Cluster Security Group"
eks_cluster_sg_description = "Allow All inbound traffic from Self and all outbound traffic"
eks_cluster_sg_vpc_id      = "vpc-064f95e6b9ba1df03"
eks_cluster_sg_tags = {
  Name                                   = "eks-cluster-sg-prod"
  "kubernetes.io/cluster/project-x-prod" = "owned"
  "aws:eks:cluster-name"                 = "project-x-prod"
}
ingress_port_ipv4     = 0
ingress_protocol_ipv4 = "-1"
egress_cidr_ipv4      = "0.0.0.0/0"
egress_protocol_ipv4  = "-1"
egress_cidr_ipv6      = "::/0"
egress_protocol_ipv6  = "-1"

##### EKS Workers IAM Role #####
eks_workers_iam_role_name             = "eks-workers"
eks_workers_iam_role_action           = "sts:AssumeRole"
eks_workers_iam_role_effect           = "Allow"
eks_workers_iam_role_service          = "ec2.amazonaws.com"
eks_workers_policy_attachment_arn     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
eks_cni_policy_attachment_arn         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
eks_autoscaling_policy_attachment_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

##### EKS Worker nodes #####
node_group_name           = "project-x-dev"
node_group_subnet_ids     = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
scaling_config_desired    = 2
scaling_config_max        = 3
scaling_config_min        = 1
node_group_ami_type       = "AL2_x86_64"
node_group_instance_types = ["t3.medium"]

##### RDS #####

allocated_storage           = 20
storage_type                = "gp2"
engine                      = "postgres"
engine_version              = "16.2"
instance_class              = "db.t3.micro"
db_name                     = "ReviewsAppData"
identifier                  = "reviews-app-db"
username                    = "milestone"
manage_master_user_password = "true"
backup_retention_period     = 7
skip_final_snapshot         = "true"
rds_tags_name               = "reviews-app-db"
rds_sg_name                 = "rds-postgres-sg"
rds_sg_description          = "Security group for RDS PostgreSQL that allows traffic from EKS cluster"
rds_sg_vpc                  = "vpc-064f95e6b9ba1df03"
rds_ingress_port            = 5432
rds_ingress_protocol        = "tcp"
rds_egress_port             = 0
rds_egress_protocol         = "-1"
rds_egress_cidr             = ["0.0.0.0/0"]
rds_sg_tags_name            = "RDS PostgreSQL Security Group"


#