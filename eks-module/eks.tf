resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.cluster_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_cidr
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
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
    effect = var.policy_effect

    principals {
      type        = var.policy_type
      identifiers = var.policy_identifiers
    }

    actions = var.policy_actions
  }
}

# create IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attach policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  policy_arn = var.attachment_policy_arn
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_cluster_sg_name
  description = var.eks_cluster_sg_description
  vpc_id      = var.eks_cluster_sg_vpc_id

  tags = var.eks_cluster_sg_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  referenced_security_group_id         = aws_security_group.eks_cluster_sg.id
  from_port         = var.ingress_port_ipv4
  ip_protocol       = var.ingress_protocol_ipv4
  to_port           = var.ingress_port_ipv4
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4         = var.egress_cidr_ipv4
  ip_protocol       = var.egress_protocol_ipv4 # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv6         = var.egress_cidr_ipv6
  ip_protocol       = var.egress_protocol_ipv6 # semantically equivalent to all ports
}

# 
output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}
