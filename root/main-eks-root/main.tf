# Define the main EKS cluster module using a local source path.
module "project-x-eks-cluster" {
  source = "../../eks-module"  # Path to the EKS module source code.

  # Assign values from variables to the EKS cluster module.
  eks_name                  = var.eks_name  # Name of the EKS cluster.
  eks_version               = var.eks_version  # Kubernetes version for the EKS cluster.
  eks_vpc_subnet_ids        = var.eks_vpc_subnet_ids  # Subnet IDs for the EKS cluster.
  k8_net_config_cidr        = var.k8_net_config_cidr  # CIDR for Kubernetes network configuration.
  tag_name                  = var.tag_name  # General tag applied to resources.
  iam_pol_effect            = var.iam_pol_effect  # Effect for the IAM policy (Allow or Deny).
  iam_pol_prin_type         = var.iam_pol_prin_type  # Type of principal (e.g., Service).
  iam_pol_prin_identifiers  = var.iam_pol_prin_identifiers  # Identifiers for the IAM policy principal.
  iam_pol_actions           = var.iam_pol_actions  # Actions allowed by the IAM policy.
  iam_role_name             = var.iam_role_name  # Name of the IAM role associated with the cluster.
  iam_role_policy_arn       = var.iam_role_policy_arn  # ARN of the IAM policy attached to the role.
  eks_sg_name               = var.eks_sg_name  # Name of the security group for the EKS cluster.
  eks_sg_description        = var.eks_sg_description  # Description of the security group.
  eks_sg_vpc_id             = var.eks_sg_vpc_id  # VPC ID where the security group is created.
  eks_sg_tag                = var.eks_sg_tag  # Tags associated with the security group.
  sg_allow_tls_port         = var.sg_allow_tls_port  # TLS port to allow through the security group.
  sg_all_ipv4_traffic       = var.sg_all_ipv4_traffic  # Allow all IPv4 traffic.
  sg_all_port_protocol      = var.sg_all_port_protocol  # Protocol for the port configuration.
  sg_all_ipv6_traffic       = var.sg_all_ipv6_traffic  # Allow all IPv6 traffic.
  eks_worker_role_name      = var.eks_worker_role_name  # Name of the worker role in the EKS cluster.

  # Worker nodes configuration.
  worker_lt_name_prefix     = var.worker_lt_name_prefix  # Prefix for the launch template names.
  worker_lt_inst_type       = var.worker_lt_inst_type  # Instance type for the worker nodes.
  worker_asg_desired_cap    = var.worker_asg_desired_cap  # Desired capacity of the auto-scaling group.
  worker_asg_max_size       = var.worker_asg_max_size  # Maximum size of the auto-scaling group.
  worker_asg_min_size       = var.worker_asg_min_size  # Minimum size of the auto-scaling group.
  worker_asg_base_cap       = var.worker_asg_base_cap  # Base on-demand capacity before using spot instances.
  worker_asg_percent_base_cap = var.worker_asg_percent_base_cap  # Percentage of on-demand instances above the base capacity.
  worker_asg_spot_strategy  = var.worker_asg_spot_strategy  # Spot instance strategy for the auto-scaling group.
  override_inst_type_1      = var.override_inst_type_1  # First instance type override for mixed instances.
  override_weight_cap_1     = var.override_weight_cap_1  # Weighted capacity for the first override instance type.
  override_inst_type_2      = var.override_inst_type_2  # Second instance type override for mixed instances.
  override_weight_cap_2     = var.override_weight_cap_2  # Weighted capacity for the second override instance type.

  # RDS configuration passed as parameters to the module.
  rds_master_username       = var.rds_master_username  # Username for the master user of the RDS instance.
  rds_master_password       = var.rds_master_password  # Password for the master user of the RDS instance.
}

# Define the RDS PostgreSQL module with configuration parameters.
module "rds_postgres" {
  source = "../../rds-postgres-module"  # Path to the RDS PostgreSQL module source code.

  # Assign values from variables and outputs to the RDS PostgreSQL module.
  eks_cluster_sg_id           = module.project-x-eks-cluster.worker_security_group_id  # Security group ID from the EKS module.
  subnet_ids                  = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Subnets for the RDS instance.
  allocated_storage           = 20  # Allocated storage in GB for the RDS instance.
  storage_type                = "gp2"  # Storage type for the RDS instance.
  engine                      = "postgres"  # Database engine type.
  engine_version              = "16.2"  # Version of the database engine.
  instance_class              = "db.t3.micro"  # Instance class for the RDS instance.
  db_name                     = "reviews_app_data"  # Database name.
  identifier                  = "reviews-app-db"  # Identifier for the RDS instance.
  rds_master_username         = var.rds_master_username  # Username for the RDS master user.
  rds_master_password         = var.rds_master_password  # Password for the RDS master user.
  manage_master_user_password = true  # Whether to manage the master user password with AWS Secrets Manager.
  backup_retention_period     = 7  # Number of days to retain backups.
  skip_final_snapshot         = true  # Whether to skip the final snapshot upon deletion.
  rds_tags_name               = "reviews-app-db"  # Tag name for the RDS instance.
  rds_sg_name                 = "rds-postgres-sg"  # Name of the security group for the RDS instance.
  rds_sg_description          = "Security group for RDS PostgreSQL"  # Description of the RDS security group.
  rds_sg_vpc                  = "vpc-064f95e6b9ba1df03"  # VPC ID for the security group.
  rds_ingress_port            = 5432  # Ingress port for PostgreSQL.
  rds_ingress_protocol        = "tcp"  # Ingress protocol for PostgreSQL.
  rds_egress_port             = 0  # Egress port, set to 0 for all ports.
  rds_egress_protocol         = "-1"  # Egress protocol, set to '-1' for all protocols.
  rds_egress_cidr             = ["0.0.0.0/0"]  # CIDR blocks for egress rules.
  rds_sg_tags_name            = "rds-postgres-sg"  # Tag name for the RDS security group.
}
