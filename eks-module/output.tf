output "eks_cluster_sg_id" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

# output "worker_node_arn" {
#   value = data.aws_eks_node_group.my_node_group.arn
# }

# output "kubectl_access_role_arn" {
#   value       = aws_iam_role.kubectl_access_role.arn
# }

