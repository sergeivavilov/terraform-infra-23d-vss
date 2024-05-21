resource "aws_eks_node_group" "project-x-node-group" {
  cluster_name    = var.name
  node_group_name = "${var.name}-node-group"
  node_role_arn   = aws_iam_role.example.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.capacity[0]
    max_size     = var.capacity[1]
    min_size     = var.capacity[2]
  }

  launch_template {
    version = aws_launch_template.eks_workers.latest_version
    id      = aws_launch_template.eks_workers.id
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    null_resource.update_aws_auth
    #kubernetes_config_map.aws_auth
  ]
}


resource "aws_iam_role" "example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example.name
}

