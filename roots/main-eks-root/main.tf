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
  ##### Workers LT #####
  eks_workers_lt_name          = var.eks_workers_lt_name
  eks_workers_lt_instance_type = var.eks_workers_lt_instance_type
  ##### Workers ASG #####
  capacity_rebalance                       = var.capacity_rebalance
  desired_capacity                         = var.desired_capacity
  max_size                                 = var.max_size
  min_size                                 = var.min_size
  vpc_zone_identifier                      = var.vpc_zone_identifier
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_allocation_strategy                 = var.spot_allocation_strategy
  lt_override_instance_type_1              = var.lt_override_instance_type_1
  lt_override_weighted_capacity_1          = var.lt_override_weighted_capacity_1
  lt_override_instance_type_2              = var.lt_override_instance_type_2
  lt_override_weighted_capacity_2          = var.lt_override_weighted_capacity_2
}
