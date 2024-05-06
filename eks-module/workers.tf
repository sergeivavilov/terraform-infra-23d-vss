locals {
  version = "1.29"
}
data "aws_ssm_parameter" "eks_ami_id" {
  name = "/aws/service/eks/optimized-ami/${local.version}/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_workers" {
  name_prefix   = "${var.name}-eks-worker-nodes"
  image_id      = data.aws_ssm_parameter.eks_ami_id.value
  instance_type = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.example.arn
  }
  vpc_security_group_ids = [aws_security_group.eks_worker_sg.id]
  user_data = base64encode(<<-EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh project-x-dev
EOF
)
}

resource "aws_iam_instance_profile" "example" {
  name = "eks-node-group-example"
  role = aws_iam_role.example.name
}

resource "aws_autoscaling_group" "eks_workers" {
  capacity_rebalance  = true
  desired_capacity    = var.capacity[0]
  max_size            = var.capacity[1]
  min_size            = var.capacity[2]
  availability_zones = [var.availability-zone]
 
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = var.spot_allocation_strategy
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_workers.id
      }

      override {
        instance_type     = var.instance_type
        weighted_capacity = "2"
      }

      override {
        instance_type     = var.alternative_instance_type
        weighted_capacity = "2"
      }
    }
  }
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

### security group for worker nodes

resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "Security group for EKS worker nodes"
  
  vpc_id      = var.vpc_id
   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
  
   ingress {
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

output "sg-id" {
  value = aws_security_group.eks_worker_sg.id
}
