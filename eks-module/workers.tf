
data "aws_ssm_parameter" "eks_ami_id" {
  name = "/aws/service/eks/optimized-ami/1.29/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_workers" {
  name_prefix   = "${var.name}-eks-worker-nodes"
  image_id      = data.aws_ssm_parameter.eks_ami_id.value
  instance_type = var.instance_type
  depends_on = [null_resource.update_aws_auth,# kubernetes_config_map.aws_auth,
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
  aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly]

  vpc_security_group_ids = [aws_security_group.eks_worker_sg.id]
  user_data = base64encode(<<-EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.name}
EOF
  )
}

resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "Security group for EKS worker nodes"

  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "worker_sg" {
  value = aws_security_group.eks_worker_sg
}