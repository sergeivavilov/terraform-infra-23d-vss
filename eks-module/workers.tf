# Define local variable for AMI version used in fetching the AMI ID.
locals {
  version = "1.29"  # Specifies the version of the Amazon Linux 2 AMI.
}

# Fetch the AMI ID for the specified version from the AWS SSM Parameter Store.
data "aws_ssm_parameter" "eks_ami_id" {
  name = "/aws/service/eks/optimized-ami/${local.version}/amazon-linux-2/recommended/image_id"  # SSM parameter name.
}

# Define a launch template for EKS worker nodes.
resource "aws_launch_template" "eks_workers" {
  name_prefix   = var.worker_lt_name_prefix  # Prefix for launch template names, ensures unique names.
  image_id      = data.aws_ssm_parameter.eks_ami_id.value  # AMI ID fetched from SSM.
  instance_type = var.worker_lt_inst_type  # Instance type for worker nodes.

  # User data scripts are commented out; they configure the instance on launch.
  # #!/bin/bash
  # set -o xtrace
  # /etc/eks/bootstrap.sh project-x-dev

  # IAM policies commented out, intended for attachment to the role.
  # iam::aws:policy/AmazonEKSWorkerNodePolicy"
  # iam::aws:policy/AmazonEKS_CNI_Policy"
  # iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Define an Auto Scaling Group (ASG) for managing EKS worker nodes.
resource "aws_autoscaling_group" "eks_workers" {
  capacity_rebalance  = true  # Enables capacity rebalancing for Spot Instances.
  desired_capacity    = var.worker_asg_desired_cap  # Desired number of instances in the ASG.
  max_size            = var.worker_asg_max_size  # Maximum number of instances in the ASG.
  min_size            = var.worker_asg_min_size  # Minimum number of instances in the ASG.
  vpc_zone_identifier = var.eks_vpc_subnet_ids  # Subnet IDs for the instances in the ASG.

  # Defines the mixed instances policy for cost optimization.
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.worker_asg_base_cap  # Minimum on-demand instances.
      on_demand_percentage_above_base_capacity = var.worker_asg_percent_base_cap  # Percentage of on-demand instances above the base.
      spot_allocation_strategy                 = var.worker_asg_spot_strategy  # Spot allocation strategy to use.
    }

    # Defines the launch template and its overrides for the ASG.
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_workers.id  # References the launch template created above.
      }

      # Override configurations for different instance types.
      override {
        instance_type     = var.override_inst_type_1  # First instance type override.
        weighted_capacity = var.override_weight_cap_1  # Weighted capacity for scaling.
      }

      override {
        instance_type     = var.override_inst_type_2  # Second instance type override.
        weighted_capacity = var.override_weight_cap_2  # Weighted capacity for scaling.
      }
    }
  }
}

# The following resources are commented out; they are examples of defining and attaching IAM roles and policies.
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
