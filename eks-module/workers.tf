locals {
  version = "1.29"
}
data "aws_ssm_parameter" "eks_ami_id" {
  name = "/aws/service/eks/optimized-ami/${local.version}/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_workers" {
  name_prefix   = var.worker_lt_name_prefix
  image_id      = data.aws_ssm_parameter.eks_ami_id.value
  instance_type = var.worker_lt_inst_type

    # #!/bin/bash
    # set -o xtrace
    # /etc/eks/bootstrap.sh project-x-dev

# iam::aws:policy/AmazonEKSWorkerNodePolicy"
# iam::aws:policy/AmazonEKS_CNI_Policy"
# iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_autoscaling_group" "eks_workers" {
  capacity_rebalance  = true
  desired_capacity    = var.worker_asg_desired_cap
  max_size            = var.worker_asg_max_size
  min_size            = var.worker_asg_min_size
  vpc_zone_identifier = var.eks_vpc_subnet_ids

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.worker_asg_base_cap
      on_demand_percentage_above_base_capacity = var.worker_asg_percent_base_cap
      spot_allocation_strategy                 = var.worker_asg_spot_strategy
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_workers.id
      }

      override {
        instance_type     = var.override_inst_type_1
        weighted_capacity = var.override_weight_cap_1
      }

      override {
        instance_type     = var.override_inst_type_2
        weighted_capacity = var.override_weight_cap_2
      }
    }
  }
}

# resource "aws_iam_role" "example" {
#   name = "eks-node-group-example"

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

# resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.example.name
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.example.name
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.example.name
# }
