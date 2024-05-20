##### EKS Workers IAM Role #####

resource "aws_iam_role" "eks_workers" {
  name = var.eks_workers_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = var.eks_workers_iam_role_action
        Effect = var.eks_workers_iam_role_effect
        Principal = {
          Service = var.eks_workers_iam_role_service
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_workers" {
  role       = aws_iam_role.eks_workers.name
  policy_arn = var.eks_workers_policy_attachment_arn
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_workers.name
  policy_arn = var.eks_cni_policy_attachment_arn
}

resource "aws_iam_role_policy_attachment" "eks_autoscaling" {
  role       = aws_iam_role.eks_workers.name
  policy_arn = var.eks_autoscaling_policy_attachment_arn
}


##### EKS Worker Nodes #####

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_workers.arn
  subnet_ids      = var.node_group_subnet_ids

  scaling_config {
    desired_size = var.scaling_config_desired
    max_size     = var.scaling_config_max
    min_size     = var.scaling_config_min
  }

  ami_type       = var.node_group_ami_type
  instance_types = var.node_group_instance_types
}

#
