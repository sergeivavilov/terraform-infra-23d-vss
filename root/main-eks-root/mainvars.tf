##### EKS Cluster #####

variable "cluster_name" {
  type    = string
  default = "project-x-dev"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "cluster_subnet_ids" {
  type    = list(string)
  default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
}

variable "cluster_cidr" {
  type    = string
  default = "10.7.0.0/16"
}

variable "cluster_tag" {
  type    = string
  default = "project-x"
}

##### Trust policy #####
variable "policy_effect" {
  type    = string
  default = "Allow"
}

variable "policy_type" {
  type    = string
  default = "Service"
}

variable "policy_identifiers" {
  type    = list(string)
  default = ["eks.amazonaws.com"]
}

variable "policy_actions" {
  type    = list(string)
  default = ["sts:AssumeRole"]
}

##### IAM Role #####
variable "role_name" {
  type    = string
  default = "project-x-dev-eks-iam-role"
}

##### Role policy attachment #####
variable "attachment_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

##### EKS Cluster sg #####
variable "eks_cluster_sg_name" {
  type    = string
  default = "EKS Cluster Security Group"
}

variable "eks_cluster_sg_description" {
  type    = string
  default = "Allow All inbound traffic from Self and all outbound traffic"
}

variable "eks_cluster_sg_vpc_id" {
  type    = string
  default = "vpc-064f95e6b9ba1df03"
}

variable "eks_cluster_sg_tags" {
  type = map(string)
  default = {
    Name                                  = "eks-cluster-sg"
    "kubernetes.io/cluster/project-x-dev" = "owned"
    "aws:eks:cluster-name"                = "project-x-dev"
  }
}

variable "ingress_port_ipv4" {
  type    = number
  default = 0
}

variable "ingress_protocol_ipv4" {
  type    = string
  default = "-1"
}

variable "egress_cidr_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}

variable "egress_protocol_ipv4" {
  type    = string
  default = "-1"
}

variable "egress_cidr_ipv6" {
  type    = string
  default = "::/0"
}

variable "egress_protocol_ipv6" {
  type    = string
  default = "-1"
}



##### Workers LT #####

# variable "eks_workers_lt_name" {
#   type    = string
#   default = "project-x-eks-dev-worker-nodes"
# }

# variable "eks_workers_lt_instance_type" {
#   type    = string
#   default = "t3.medium"
# }

##### Workers ASG #####

# variable "capacity_rebalance" {
#   type    = string
#   default = "true"
# }

# variable "desired_capacity" {
#   type    = number
#   default = 2
# }

# variable "max_size" {
#   type    = number
#   default = 3
# }

# variable "min_size" {
#   type    = number
#   default = 1
# }

# variable "vpc_zone_identifier" {
#   type    = list(string)
#   default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
# }

# variable "on_demand_base_capacity" {
#   type    = number
#   default = 0
# }

# variable "on_demand_percentage_above_base_capacity" {
#   type    = number
#   default = 0
# }

# variable "spot_allocation_strategy" {
#   type    = string
#   default = "capacity-optimized"
# }

# variable "lt_override_instance_type_1" {
#   type    = string
#   default = "t3.medium"
# }

# variable "lt_override_weighted_capacity_1" {
#   type    = string
#   default = "2"
# }

# variable "lt_override_instance_type_2" {
#   type    = string
#   default = "t2.medium"
# }

# variable "lt_override_weighted_capacity_2" {
#   type    = string
#   default = "2"
# }

########## Worker Node Group ########### 


##### EKS Workers IAM Role #####

variable "eks_workers_iam_role_name" {
  type    = string
  default = "eks-workers"
}

variable "eks_workers_iam_role_action" {
  type    = string
  default = "sts:AssumeRole"
}

variable "eks_workers_iam_role_effect" {
  type    = string
  default = "Allow"
}

variable "eks_workers_iam_role_service" {
  type    = string
  default = "ec2.amazonaws.com"
}

variable "eks_workers_policy_attachment_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "eks_cni_policy_attachment_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

variable "eks_autoscaling_policy_attachment_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
##### EKS Worker nodes #####
variable "node_group_name" {
  type    = string
  default = "project-x-dev"
}

variable "node_group_subnet_ids" {
  type    = list(string)
  default = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
}

variable "scaling_config_desired" {
  type    = number
  default = 2
}

variable "scaling_config_max" {
  type    = number
  default = 3
}

variable "scaling_config_min" {
  type    = number
  default = 1
}

variable "node_group_ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "node_group_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}


##### RDS Variables #####

variable "allocated_storage" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "identifier" {
  type = string
}

variable "username" {
  type = string
}

variable "manage_master_user_password" {
  type = string
}

variable "backup_retention_period" {
  type = string
}

variable "skip_final_snapshot" {
  type = string
}

variable "rds_tags_name" {
  type = string
}

variable "rds_sg_name" {
  type = string
}

variable "rds_sg_description" {
  type = string
}

variable "rds_sg_vpc" {
  type = string
}

variable "rds_ingress_port" {
  type = string
}

variable "rds_ingress_protocol" {
  type = string
}

variable "rds_egress_port" {
  type = string
}

variable "rds_egress_protocol" {
  type = string
}

variable "rds_egress_cidr" {
  type = list(string)
}

variable "rds_sg_tags_name" {
  type = string
}
