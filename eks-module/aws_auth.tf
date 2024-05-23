# this script fixes error: configmaps "aws-auth" is forbidden: User "system:anonymous" cannot get resource "configmaps"

# return current region details
data "aws_region" "current" {}

# return current user details along with account details
data "aws_caller_identity" "current" {}

# current account number
locals {
  account = data.aws_caller_identity.current.account_id
}

resource "null_resource" "update_aws_auth" {
  depends_on = [aws_eks_cluster.cluster]

# code below allows nodes to runn bootstrap script, and allows custom set of users even crossaccount to communicate to our cluster
  provisioner "local-exec" {
    command = <<-EOT
    sleep 50
    aws eks update-kubeconfig --name ${var.name} --region ${data.aws_region.current.name}
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: ${aws_iam_role.example.arn}
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:masters
      rolearn: arn:aws:iam::730335359268:user/vss1
      username: adminRoleUser
    - groups:
      - system:masters
      rolearn: arn:aws:iam::730335359268:role/GitHubActionsCICDrole
      username: CICDrole
EOF
    EOT
  }
} 