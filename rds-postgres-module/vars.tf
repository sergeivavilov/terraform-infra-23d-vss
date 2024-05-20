variable "eks_cluster_sg_id" {
  type = list(string)
}

# variable rds_vpc {
#   type        = string
# }

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