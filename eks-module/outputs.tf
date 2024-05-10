output "worker_security_group_id" {
  value = aws_security_group.eks_worker_sg.id
}

output "worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn
}
