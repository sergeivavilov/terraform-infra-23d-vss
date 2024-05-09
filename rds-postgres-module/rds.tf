resource "aws_db_instance" "reviews_app_db" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  identifier           = var.identifier
  username             = var.rds_master_username
  password             = var.rds_master_password # Ensure this is managed securely
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Name = var.rds_tags_name
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = var.rds_sg_description
  vpc_id      = var.rds_sg_vpc

  ingress {
    from_port       = var.rds_ingress_port
    to_port         = var.rds_ingress_port
    protocol        = var.rds_ingress_protocol
    security_groups = var.eks_cluster_sg_id
  }

  egress {
    from_port   = var.rds_egress_port
    to_port     = var.rds_egress_port
    protocol    = var.rds_egress_protocol
    cidr_blocks = var.rds_egress_cidr
  }

  tags = {
    Name = var.rds_sg_tags_name
  }
}


