resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.CIDR
  }

  # make sure to add this so the cluster creates after the role exists
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role-AmazonEKSClusterPolicy
  ]

  tags = {
    Name = var.cluster_tag
  }
}


# trust policy for the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# create IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.name}-eks-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


# security group for cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "EKS updated group"
  description = "Security group for all inbound and outbound traffic for EKS"
  vpc_id      = var.vpc_id
}
resource "aws_vpc_security_group_ingress_rule" "allow_worker_traffic" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
  referenced_security_group_id = aws_security_group.eks_worker_sg.id
}
resource "aws_vpc_security_group_ingress_rule" "allow_self_traffic" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
} 

# CNI add-on that is missing from EKS configuration
resource "aws_eks_addon" "cni_pluggin" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.1-eksbuild.1"
  depends_on    = [aws_eks_cluster.cluster]
}
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "kube-proxy"
  addon_version = "v1.29.1-eksbuild.2" 
  depends_on    = [aws_eks_cluster.cluster]
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority
}
