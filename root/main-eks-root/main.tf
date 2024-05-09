module "project-x-eks-cluster" {
  source = "../../eks-module"

  ### eks.tf ###
  eks_name                  = var.eks_name
  eks_version               = var.eks_version
  eks_vpc_subnet_ids        = var.eks_vpc_subnet_ids
  k8_net_config_cidr        = var.k8_net_config_cidr
  tag_name                  = var.tag_name
  iam_pol_effect            = var.iam_pol_effect
  iam_pol_prin_type         = var.iam_pol_prin_type
  iam_pol_prin_identifiers  = var.iam_pol_prin_identifiers
  iam_pol_actions           = var.iam_pol_actions
  iam_role_name             = var.iam_role_name
  iam_role_policy_arn       = var.iam_role_policy_arn
  eks_sg_name               = var.eks_sg_name
  eks_sg_description        = var.eks_sg_description
  eks_sg_vpc_id             = var.eks_sg_vpc_id
  eks_sg_tag                = var.eks_sg_tag
  sg_allow_tls_port         = var.sg_allow_tls_port
  sg_all_ipv4_traffic       = var.sg_all_ipv4_traffic
  sg_all_port_protocol      = var.sg_all_port_protocol
  sg_all_ipv6_traffic       = var.sg_all_ipv6_traffic

  ### workers.tf ###
  worker_lt_name_prefix     = var.worker_lt_name_prefix
  worker_lt_inst_type       = var.worker_lt_inst_type
  worker_asg_desired_cap    = var.worker_asg_desired_cap
  worker_asg_max_size       = var.worker_asg_max_size
  worker_asg_min_size       = var.worker_asg_min_size
  worker_asg_base_cap       = var.worker_asg_base_cap
  worker_asg_percent_base_cap = var.worker_asg_percent_base_cap
  worker_asg_spot_strategy  = var.worker_asg_spot_strategy
  override_inst_type_1      = var.override_inst_type_1
  override_weight_cap_1     = var.override_weight_cap_1
  override_inst_type_2      = var.override_inst_type_2
  override_weight_cap_2     = var.override_weight_cap_2
}

module "rds_postgres" {
  source = "../../rds-postgres-module"

  eks_cluster_sg_id           = module.project-x-eks-cluster.worker_security_group_id
  subnet_ids                  = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]  # Subnets in us-east-1a and us-east-1b
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = "16.2"
  instance_class              = "db.t3.micro"
  db_name                     = "reviews_app_data"
  identifier                  = "reviews-app-db"
  rds_master_username         = var.rds_master_username
  rds_master_password         = var.rds_master_password
  manage_master_user_password = true
  backup_retention_period     = 7
  skip_final_snapshot         = true
  rds_tags_name               = "reviews-app-db"
  rds_sg_name                 = "rds-postgres-sg"
  rds_sg_description          = "Security group for RDS PostgreSQL"
  rds_sg_vpc                  = "vpc-064f95e6b9ba1df03"
  rds_ingress_port            = 5432
  rds_ingress_protocol        = "tcp"
  rds_egress_port             = 0
  rds_egress_protocol         = "-1"
  rds_egress_cidr             = ["0.0.0.0/0"]
  rds_sg_tags_name            = "rds-postgres-sg"
}
