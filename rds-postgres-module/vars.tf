variable "eks_cluster_sg_id" {
  description = "Security group ID of the EKS cluster"
  type = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for the RDS subnet group"
  type = list(string)
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type = number
}

variable "storage_type" {
  description = "The storage type (e.g., gp2, io1)"
  type = string
}

variable "engine" {
  description = "The database engine (e.g., postgres)"
  type = string
}

variable "engine_version" {
  description = "The database engine version"
  type = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type = string
}

variable "db_name" {
  description = "The name of the database to create"
  type = string
}

variable "identifier" {
  description = "The identifier for the RDS instance"
  type = string
}

variable "username" {
  description = "The master username for the RDS instance"
  type = string
}

variable "password" {
  description = "The master password for the RDS instance"
  type = string
  sensitive = true
}

variable "manage_master_user_password" {
  description = "Whether to manage the master user password with AWS Secrets Manager"
  type = bool
  default = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type = number
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the instance"
  type = bool
}

variable "rds_tags_name" {
  description = "The name tag for the RDS instance"
  type = string
}

variable "rds_sg_name" {
  description = "The name of the security group for the RDS instance"
  type = string
}

variable "rds_sg_description" {
  description = "The description of the security group for the RDS instance"
  type = string
}

variable "rds_sg_vpc" {
  description = "The VPC ID for the security group"
  type = string
}

variable "rds_ingress_port" {
  description = "The ingress port for the RDS security group"
  type = number
  default = 5432
}

variable "rds_ingress_protocol" {
  description = "The ingress protocol for the RDS security group"
  type = string
  default = "tcp"
}

variable "rds_egress_port" {
  description = "The egress port for the RDS security group"
  type = number
  default = 0
}

variable "rds_egress_protocol" {
  description = "The egress protocol for the RDS security group"
  type = string
  default = "-1"
}

variable "rds_egress_cidr" {
  description = "The egress CIDR blocks for the RDS security group"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "rds_sg_tags_name" {
  description = "The name tag for the RDS security group"
  type = string
}

