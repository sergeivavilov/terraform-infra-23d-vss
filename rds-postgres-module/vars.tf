# Variable definitions for Terraform configuration.

# Security group ID variable for the EKS cluster.
variable "eks_cluster_sg_id" {
  description = "Security group ID of the EKS cluster"  # Description of what the variable represents.
  type        = list(string)  # Type declaration (list of strings).
}

# Subnet IDs variable for the RDS subnet group.
variable "subnet_ids" {
  description = "Subnet IDs for the RDS subnet group"  # Description of what the variable represents.
  type        = list(string)  # Type declaration (list of strings).
}

# Allocated storage variable for the RDS instance.
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"  # Description of what the variable represents.
  type        = number  # Type declaration (number).
}

# Storage type variable for the RDS instance.
variable "storage_type" {
  description = "The storage type (e.g., gp2, io1)"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Database engine type variable.
variable "engine" {
  description = "The database engine (e.g., postgres)"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Database engine version variable.
variable "engine_version" {
  description = "The database engine version"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Instance class variable for the RDS instance.
variable "instance_class" {
  description = "The instance class for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Database name variable.
variable "db_name" {
  description = "The name of the database to create"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Identifier variable for the RDS instance.
variable "identifier" {
  description = "The identifier for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Master username variable for the RDS instance.
variable "rds_master_username" {
  description = "The master username for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Master password variable for the RDS instance.
variable "rds_master_password" {
  description = "The master password for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
  sensitive   = true  # Marks the variable as sensitive.
}

# Variable to decide whether to manage the master user password with AWS Secrets Manager.
variable "manage_master_user_password" {
  description = "Whether to manage the master user password with AWS Secrets Manager"  # Description of what the variable represents.
  type        = bool  # Type declaration (boolean).
  default     = true  # Default value (true).
}

# Backup retention period variable for the RDS instance.
variable "backup_retention_period" {
  description = "The number of days to retain backups"  # Description of what the variable represents.
  type        = number  # Type declaration (number).
}

# Variable to decide whether to skip the final snapshot when deleting the RDS instance.
variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the instance"  # Description of what the variable represents.
  type        = bool  # Type declaration (boolean).
}

# Tags name variable for the RDS instance.
variable "rds_tags_name" {
  description = "The name tag for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Security group name variable for the RDS instance.
variable "rds_sg_name" {
  description = "The name of the security group for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Security group description variable for the RDS instance.
variable "rds_sg_description" {
  description = "The description of the security group for the RDS instance"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# VPC ID variable for the security group.
variable "rds_sg_vpc" {
  description = "The VPC ID for the security group"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}

# Ingress port variable for the RDS security group.
variable "rds_ingress_port" {
  description = "The ingress port for the RDS security group"  # Description of what the variable represents.
  type        = number  # Type declaration (number).
  default     = 5432  # Default value (5432).
}

# Ingress protocol variable for the RDS security group.
variable "rds_ingress_protocol" {
  description = "The ingress protocol for the RDS security group"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
  default     = "tcp"  # Default value ("tcp").
}

# Egress port variable for the RDS security group.
variable "rds_egress_port" {
  description = "The egress port for the RDS security group"  # Description of what the variable represents.
  type        = number  # Type declaration (number).
  default     = 0  # Default value (0).
}

# Egress protocol variable for the RDS security group.
variable "rds_egress_protocol" {
  description = "The egress protocol for the RDS security group"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
  default     = "-1"  # Default value ("-1").
}

# Egress CIDR blocks variable for the RDS security group.
variable "rds_egress_cidr" {
  description = "The egress CIDR blocks for the RDS security group"  # Description of what the variable represents.
  type        = list(string)  # Type declaration (list of strings).
  default     = ["0.0.0.0/0"]  # Default value ("0.0.0.0/0").
}

# Tags name variable for the RDS security group.
variable "rds_sg_tags_name" {
  description = "The name tag for the RDS security group"  # Description of what the variable represents.
  type        = string  # Type declaration (string).
}