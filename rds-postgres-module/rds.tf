# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_db_instance" "reviews_app_db" {
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  identifier                  = var.identifier
  username                    = var.username
  manage_master_user_password = var.manage_master_user_password
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Name = var.rds_tags_name
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

# data "aws_secretsmanager_secret" "db_credentials_secret" {
#   arn = aws_db_instance.reviews_app_db.master_user_secret[0].secret_arn
# }

# data "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = data.aws_secretsmanager_secret.db_credentials_secret.id
# }

# resource "aws_secretsmanager_secret" "combined_db_secret" {
#   name = "${var.identifier}-combined-secret"
# }

# resource "aws_secretsmanager_secret_version" "combined_db_secret_version" {
#   secret_id = aws_secretsmanager_secret.combined_db_secret.id

#   secret_string = jsonencode({
#     username    = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).username
#     password    = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).password
#     DB_ENDPOINT = aws_db_instance.reviews_app_db.endpoint
#     DB_NAME     = aws_db_instance.reviews_app_db.db_name
#   })
# }

