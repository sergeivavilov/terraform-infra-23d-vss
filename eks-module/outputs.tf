# This is a commented-out output for the security group ID of EKS worker nodes.
# output "worker_security_group_id" {
#   value = aws_security_group.eks_worker_sg.id  # Retrieves the ID of the EKS worker security group.
# }

# Output the ARN of the IAM role for EKS worker nodes.
output "worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn  # Retrieves the ARN of the IAM role assigned to EKS worker nodes.
}
