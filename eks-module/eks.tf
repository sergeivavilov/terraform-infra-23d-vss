resource "aws_eks_cluster" "cluster" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.eks_vpc_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.k8_net_config_cidr
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role-AmazonEKSClusterPolicy
  ]

  tags = {
    Name = var.tag_name
  }
}

# trust policy for the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = var.iam_pol_effect

    principals {
      type        = var.iam_pol_prin_type
      identifiers = var.iam_pol_prin_identifiers
    }

    actions = var.iam_pol_actions
  }
}

# create IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attach policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  policy_arn = var.iam_role_policy_arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_sg_name
  description = var.eks_sg_description
  vpc_id      = var.eks_sg_vpc_id

  tags = var.eks_sg_tag
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id             = aws_security_group.eks_cluster_sg.id
  referenced_security_group_id  = aws_security_group.eks_cluster_sg.id
  from_port                     = var.sg_allow_tls_port
  ip_protocol                   = "tcp"
  to_port                       = var.sg_allow_tls_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4         = var.sg_all_ipv4_traffic
  ip_protocol       = var.sg_all_port_protocol
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv6         = var.sg_all_ipv6_traffic
  ip_protocol       = var.sg_all_port_protocol
}

# Define the eks_worker_sg resource
resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.eks_sg_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-sg"
  }
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "worker_security_group_id" {
  value = [aws_security_group.eks_worker_sg.id]
}

# The following resources were commented out:
# 
# resource "aws_iam_role" "example" {
#   name = "eks-node-group-example"
# 
#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }
# 
# resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.example.name
# }
# 
# resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.example.name
# }
# 
# resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.example.name
# }


