# Define an AWS DB instance for a reviews application.
resource "aws_db_instance" "reviews_app_db" {
  allocated_storage    = var.allocated_storage  # The amount of allocated storage in gigabytes.
  storage_type         = var.storage_type  # The type of storage (e.g., standard, gp2, io1).
  engine               = var.engine  # The database engine type (e.g., MySQL, PostgreSQL).
  engine_version       = var.engine_version  # The version of the database engine.
  instance_class       = var.instance_class  # The compute and memory capacity of the DB instance.
  db_name              = var.db_name  # The name of the database to create when the DB instance is created.
  identifier           = var.identifier  # The identifier for the DB instance.
  username             = var.rds_master_username  # The master user name for the DB instance.
  password             = var.rds_master_password  # The password for the master database user. Managed securely.
  #   manage_master_user_password = var.manage_master_user_password  # Whether to manage the master user password with AWS Secrets Manager.
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  # List of VPC security group IDs to associate.
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name  # The name of the DB subnet group.

  backup_retention_period = var.backup_retention_period  # The number of days to retain backups.
  skip_final_snapshot     = var.skip_final_snapshot  # Determines whether a final DB snapshot is created before deletion.

  tags = {
    Name = var.rds_tags_name  # Tags assigned to the DB instance.
  }
}

# Define a DB subnet group for PostgreSQL.
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres_group"  # The name of the DB subnet group.
  subnet_ids = var.subnet_ids  # The IDs of the subnets in the VPC.

  tags = {
    Name = "My DB subnet group"  # Tags assigned to the DB subnet group.
  }
}

# Define a security group for the RDS instance.
resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name  # The name of the security group.
  description = var.rds_sg_description  # Description of the security group.
  vpc_id      = var.rds_sg_vpc  # The VPC ID where the security group is created.

  # Defines ingress rules for the security group.
  ingress {
    from_port       = var.rds_ingress_port  # The starting port of ingress traffic.
    to_port         = var.rds_ingress_port  # The ending port of ingress traffic.
    protocol        = var.rds_ingress_protocol  # The protocol used for ingress traffic.
    security_groups = var.eks_cluster_sg_id  # The IDs of security groups that allow ingress traffic.
  }

  # Defines egress rules for the security group.
  egress {
    from_port   = var.rds_egress_port  # The starting port of egress traffic.
    to_port     = var.rds_egress_port  # The ending port of egress traffic.
    protocol    = var.rds_egress_protocol  # The protocol used for egress traffic.
    cidr_blocks = var.rds_egress_cidr  # CIDR blocks to which the egress rule applies.
  }

  tags = {
    Name = var.rds_sg_tags_name  # Tags assigned to the security group.
  }
}