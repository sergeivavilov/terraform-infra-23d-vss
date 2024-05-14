# Define the AWS EKS cluster with specific configurations.
resource "aws_eks_cluster" "cluster" {
  name     = var.eks_name  # Name of the EKS cluster.
  role_arn = aws_iam_role.eks_cluster_role.arn  # ARN of the IAM role for the EKS cluster.
  version  = var.eks_version  # Version of Kubernetes to use for the EKS cluster.

  # Configuration for the VPC settings of the EKS cluster.
  vpc_config {
    subnet_ids         = var.eks_vpc_subnet_ids  # List of subnet IDs for the EKS cluster.
    security_group_ids = [aws_security_group.eks_cluster_sg.id]  # List of security group IDs attached to the EKS cluster.
  }

  # Configuration for the Kubernetes network settings within the EKS cluster.
  kubernetes_network_config {
    service_ipv4_cidr = var.k8_net_config_cidr  # CIDR block for Kubernetes service IP addresses.
  }

  # Ensures that the specified IAM role permissions are correctly set up before creating the EKS cluster.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role-AmazonEKSClusterPolicy
  ]

  # Tags to assign to the EKS cluster for identification and management.
  tags = {
    Name = var.tag_name  # Tag with the name of the EKS cluster.
  }
}

# Define the trust policy for the EKS cluster IAM role.
data "aws_iam_policy_document" "assume_role" {
  # Statement block within the policy document.
  statement {
    effect = var.iam_pol_effect  # Effect of the statement, typically 'Allow'.

    # Defines the principal that can assume this role.
    principals {
      type        = var.iam_pol_prin_type  # Type of principal, such as 'Service'.
      identifiers = var.iam_pol_prin_identifiers  # Identifiers of the principal, e.g., 'eks.amazonaws.com'.
    }

    actions = var.iam_pol_actions  # Actions allowed by the policy, typically 'sts:AssumeRole'.
  }
}

# Create the IAM role for the EKS cluster.
resource "aws_iam_role" "eks_cluster_role" {
  name               = var.iam_role_name  # Name of the IAM role.
  assume_role_policy = data.aws_iam_policy_document.assume_role.json  # JSON version of the policy document.

  tags = {
    Name = "eks-cluster-role"  # Tag attached to the IAM role.
  }
}

# Attach a policy to the IAM role for the EKS cluster.
resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name  # Reference to the IAM role.
  policy_arn = var.iam_role_policy_arn  # ARN of the policy to attach.
}

# Define a security group for the EKS cluster.
resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_sg_name  # Name of the security group.
  description = var.eks_sg_description  # Description of the security group.
  vpc_id      = var.eks_sg_vpc_id  # VPC ID where the security group is created.

  tags = var.eks_sg_tag  # Tags attached to the security group.
}

# Define an ingress rule for the EKS cluster security group to allow TLS traffic.
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id             = aws_security_group.eks_cluster_sg.id  # ID of the security group.
  referenced_security_group_id  = aws_security_group.eks_cluster_sg.id  # ID of the security group to reference.
  from_port                     = var.sg_allow_tls_port  # Starting port range (TLS port).
  ip_protocol                   = "tcp"  # Protocol used.
  to_port                       = var.sg_allow_tls_port  # Ending port range (TLS port).
}

# Define an egress rule for the EKS cluster security group to allow all outbound IPv4 traffic.
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.eks_cluster_sg.id  # ID of the security group.
  cidr_ipv4         = var.sg_all_ipv4_traffic  # CIDR block for outbound traffic.
  ip_protocol       = var.sg_all_port_protocol  # Protocol used, typically '-1' for all.
}

# Define an egress rule for the EKS cluster security group to allow all outbound IPv6 traffic.
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.eks_cluster_sg.id  # ID of the security group.
  cidr_ipv6         = var.sg_all_ipv6_traffic  # CIDR block for outbound traffic.
  ip_protocol       = var.sg_all_port_protocol  # Protocol used, typically '-1' for all.
}

# Define a security group for EKS worker nodes.
resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"  # Name of the security group.
  description = "Security group for EKS worker nodes"  # Description of the security group.
  vpc_id      = var.eks_sg_vpc_id  # VPC ID where the security group is created.

  # Ingress rule to allow SSH access.
  ingress {
    from_port   = 22  # SSH port.
    to_port     = 22  # SSH port.
    protocol    = "tcp"  # Protocol used.
    cidr_blocks = ["0.0.0.0/0"]  # CIDR block allowing access from any IP.
  }

  # Ingress rule to allow HTTPS access.
  ingress {
    from_port   = 443  # HTTPS port.
    to_port     = 443  # HTTPS port.
    protocol    = "tcp"  # Protocol used.
    cidr_blocks = ["0.0.0.0/0"]  # CIDR block allowing access from any IP.
  }

  # Egress rule to allow all outbound traffic.
  egress {
    from_port   = 0  # All ports.
    to_port     = 0  # All ports.
    protocol    = "-1"  # All protocols.
    cidr_blocks = ["0.0.0.0/0"]  # CIDR block allowing access to any IP.
  }

  tags = {
    Name = "eks-worker-sg"  # Tag attached to the security group.
  }
}

# Output the endpoint for the EKS cluster.
output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint  # Endpoint of the EKS cluster.
}

# Output the certificate authority data for the EKS cluster.
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data  # Certificate authority data.
}

# Output the ID of the security group for the EKS worker nodes.
output "worker_security_group_id" {
  value = [aws_security_group.eks_worker_sg.id]  # ID of the security group.
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
