module "project-x-eks-cluster" {
  source = "../../eks-module"
  ##### EKS Cluster ##### 
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  cluster_subnet_ids = var.cluster_subnet_ids
  cluster_cidr       = var.cluster_cidr
  cluster_tag        = var.cluster_tag
  ##### Trust policy #####
  policy_effect      = var.policy_effect
  policy_type        = var.policy_type
  policy_identifiers = var.policy_identifiers
  policy_actions     = var.policy_actions
  ##### IAM Role #####
  role_name = var.role_name
  ##### Role policy attachment #####
  attachment_policy_arn = var.attachment_policy_arn
  ##### EKS Cluster sg #####
  eks_cluster_sg_name        = var.eks_cluster_sg_name
  eks_cluster_sg_description = var.eks_cluster_sg_description
  eks_cluster_sg_vpc_id      = var.eks_cluster_sg_vpc_id
  eks_cluster_sg_tags        = var.eks_cluster_sg_tags
  ingress_port_ipv4          = var.ingress_port_ipv4
  ingress_protocol_ipv4      = var.ingress_protocol_ipv4
  egress_cidr_ipv4           = var.egress_cidr_ipv4
  egress_protocol_ipv4       = var.egress_protocol_ipv4
  egress_cidr_ipv6           = var.egress_cidr_ipv6
  egress_protocol_ipv6       = var.egress_protocol_ipv6
  ##### EKS Workers IAM Role #####
  eks_workers_iam_role_name             = var.eks_workers_iam_role_name
  eks_workers_iam_role_action           = var.eks_workers_iam_role_action
  eks_workers_iam_role_effect           = var.eks_workers_iam_role_effect
  eks_workers_iam_role_service          = var.eks_workers_iam_role_service
  eks_workers_policy_attachment_arn     = var.eks_workers_policy_attachment_arn
  eks_cni_policy_attachment_arn         = var.eks_cni_policy_attachment_arn
  eks_autoscaling_policy_attachment_arn = var.eks_autoscaling_policy_attachment_arn
  ##### EKS Worker nodes #####
  node_group_name           = var.node_group_name
  node_group_subnet_ids     = var.node_group_subnet_ids
  scaling_config_desired    = var.scaling_config_desired
  scaling_config_max        = var.scaling_config_max
  scaling_config_min        = var.scaling_config_min
  node_group_ami_type       = var.node_group_ami_type
  node_group_instance_types = var.node_group_instance_types
  ##### aws_auth configuration #####
}

# output "cluster_endpoint" {
#   description = "EKS cluster endpoint."
#   value       = module.project-x-eks-cluster.endpoint
# }

output "cluster_ca_data" {
  description = "EKS cluster certificate authority data."
  value       = module.project-x-eks-cluster.kubeconfig-certificate-authority-data
}

module "rds-postgres" {
  source                      = "../../rds-postgres-module"
  eks_cluster_sg_id           = [module.project-x-eks-cluster.eks_cluster_sg_id]
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  identifier                  = var.identifier
  username                    = var.username
  manage_master_user_password = var.manage_master_user_password
  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = var.skip_final_snapshot
  rds_tags_name               = var.rds_tags_name
  rds_sg_name                 = var.rds_sg_name
  rds_sg_description          = var.rds_sg_description
  rds_sg_vpc                  = var.rds_sg_vpc
  rds_ingress_port            = var.rds_ingress_port
  rds_ingress_protocol        = var.rds_ingress_protocol
  rds_egress_port             = var.rds_egress_port
  rds_egress_protocol         = var.rds_egress_protocol
  rds_egress_cidr             = var.rds_egress_cidr
  rds_sg_tags_name            = var.rds_sg_tags_name
}