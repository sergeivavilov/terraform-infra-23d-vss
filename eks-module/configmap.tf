# Define a Kubernetes ConfigMap named 'aws-auth' in the 'kube-system' namespace.
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"  # Name of the ConfigMap.
    namespace = "kube-system"  # Namespace where the ConfigMap is deployed.
  }

  data = {
    mapRoles = <<-YAML  # Map AWS IAM roles to Kubernetes roles.
- rolearn: ${aws_iam_role.eks_worker_role.arn}  # ARN of the EKS worker IAM role.
  username: system:node:{{EC2PrivateDNSName}}  # Maps the role to a username.
  groups:  # Kubernetes groups the role belongs to.
    - system:bootstrappers
    - system:nodes
YAML
  }
}


# Define an AWS IAM role for EKS workers.
resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"  # Name of the IAM role.

  # IAM policy document that allows EC2 instances to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"  # Policy language version.
    Statement = [
      {
        Effect = "Allow"  # Allows action.
        Principal = {
          Service = "ec2.amazonaws.com"  # Service allowed to assume this role.
        }
        Action = "sts:AssumeRole"  # Action that is allowed.
      },
    ]
  })

  tags = {
    Name = "eks-worker-role"  # Tag attached to the role.
  }
}

# Attach the Amazon EKS Worker Node Policy to the EKS worker role.
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_worker_role.name  # IAM role to attach the policy to.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  # ARN of the policy to attach.
}

# Attach the Amazon EKS CNI Policy to the EKS worker role.
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_worker_role.name  # IAM role to attach the policy to.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # ARN of the policy to attach.
}

# Attach the Amazon EC2 Container Registry Read-Only Policy to the EKS worker role.
resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  role       = aws_iam_role.eks_worker_role.name  # IAM role to attach the policy to.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  # ARN of the policy to attach.
}
