##################
# variables for cluster

name                      = "project-x-dev"
CIDR                      = "10.7.0.0/16"
instance_type             = "t3.medium"
vpc_id                    = "vpc-064f95e6b9ba1df03"
cluster_tag               = "project-x"
subnet_ids                = ["subnet-0d5fc4ce23b5cb89a", "subnet-06e01dd0cc5e788b9"]
alternative_instance_type = "t2.medium"
capacity                  = ["2", "3", "1"] # capacity goes: [desired, max, min] change accordingly
spot_allocation_strategy  = "capacity-optimized"
availability-zone         = "us-east-1a"
subnet_ip_range_1         = "172.31.0.0/20"
subnet_ip_range_2         = "172.31.64.0/20"


#####################
# variables for RDS

backup_retention_period = 7
engine                  = "postgres"
engine_version          = "12.19"
db_name                 = "eksdatabase"
instance_class          = "db.t3.micro"
db_username             = "vss"
db_instance_identifier  = "vssdatabase"
db_allocated_storage    = 25
db_subnet_group_name = "subnet-0d5fc4ce23b5cb89a"