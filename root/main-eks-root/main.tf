# module "project-x-eks-cluster" {
#   source                    = "../../eks-module"
#   name                      = var.name
#   CIDR                      = var.CIDR
#   instance_type             = var.instance_type
#   cluster_tag               = var.cluster_tag
#   vpc_id                    = var.vpc_id
#   subnet_ids                = var.subnet_ids
#   alternative_instance_type = var.alternative_instance_type
#   capacity                  = var.capacity # capacity list: desired, max, min
#   spot_allocation_strategy  = var.spot_allocation_strategy
#   availability-zone         = var.availability-zone
#   subnet_ip_range_1         = var.subnet_ip_range_1
#   subnet_ip_range_2         = var.subnet_ip_range_2
# }


# module "rds-mysql" {
#   source                  = "../../rds-mysql-module"
#   backup_retention_period = var.backup_retention_period
#   subnet_ids              = var.subnet_ids
#   engine                  = var.engine
#   engine_version          = var.engine_version
#   vpc_id                  = var.vpc_id
#   worker_sg               = module.project-x-eks-cluster.worker_sg.id
#   db_name                 = var.db_name
#   instance_class          = var.instance_class
#   db_username             = var.db_username
#   db_instance_identifier  = var.db_instance_identifier
#   db_allocated_storage    = var.db_allocated_storage
#   db_subnet_group_name    = var.db_subnet_group_name
# }