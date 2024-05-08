[![Terraform Deployment Workflow](https://github.com/312school/terraform-infra-23d-vss/actions/workflows/terraform-deploy.yaml/badge.svg)](https://github.com/312school/terraform-infra-23d-vss/actions/workflows/terraform-deploy.yaml)
# 312school / terraform-infra-23d


# this command to add all in one text file 
# find . -name "*.tf" -exec echo {} \; -exec cat {} \; -exec echo \; > output.txt


task : 

Assignment: Implement GitOps with Terraform for EKS and RDS Deployment
Срок среда по 22:59 Баллы 0 Отправка загрузка файла Доступно 28 Апр в 23:00 — 28 Фев 2025 r. в 22:59 10 месяца(ев)
Description: This task involves using Terraform and GitHub Actions to set up an EKS cluster and an RDS database in AWS. This hands-on project is designed to provide practical experience in implementing GitOps principles.

General Note: Do not execute any Terraform commands locally. All resources, except for remote backend and state lock, should be provisioned via GitHub Actions.

Where to provision:

GitHub: 312school Organization, repository forked from 312school, with GitHub Actions.

AWS: Personal AWS account.

Milestone #1: EKS Cluster Deployment

Task #1.1: Fork the 312school/terraform-infra-BATCH repository into your own GitHub repo (312school/terraform-infra-YOURNAME). Ensure your forked repository remains private. If you need to give access to a peer, do so directly under Repo => Settings => Collaborators and Team => Add people.

Task #1.2: Set up GitHub Actions in conjunction with AWS. Create an IAM role named GitHubActionsTerraformIAMrole in your personal AWS account, attaching the AdministratorAccess AWS managed policy. Be sure to limit permissions specifically to the organization (312school) and your repository (terraform-infra-YOURNAME).

Task #1.3: Create dev environment within your GitHub repo, and within the environment, configure variable IAM_ROLE to store the ARN of the IAM role created.

Task #1.4: Modify the workflow YAML in your GitHub Actions. Consider whether adjustments are needed for the remote state bucket location. Use a new .tfvars file named homework-project-YOUR_GITHUB_USERNAME.tfvars (e.g., homework-project-marsel-edu.tfvars). Maintain the use of the N. Virginia region and the current folder structure and terraform root module folder (./roots/project-x-main-root/).

Task #1.5: Provide access to the EKS cluster to an IAM role or user in your personal AWS account. Adjust the aws-auth configmap in the EKS module to map IAM roles/users with Kubernetes groups. Preferably provide access to an IAM role (e.g., MyAdminRole) rather than an IAM user.

Task #1.6: Troubleshoot and ensure a successful GitHub Actions workflow run that creates an EKS cluster in your AWS account.

Task #1.7: Validate your work:

Confirm the GitHub Actions workflow (including terraform init/fmt/plan/apply) completes successfully.

In Terminal, switch to an IAM role with access to the EKS cluster (not GitHubActionsTerraformIAMrole).

Request Kubeconfig from the EKS API (EKS Kubeconfig instructions (Ссылки на внешний сайт.)).

Check for worker nodes and ensure they're in ready state with kubectl get nodes.

Create a basic nginx deployment and verify the replicas are running.

Task #1.8: After verification, delete the EKS cluster to avoid incurring costs. Comment out the module trigger in the Terraform root (module "name" { ... } block), and push the changes so that GitHub Actions runs the terraform job to delete the EKS cluster.

Milestone #2: RDS Database Setup

Task #2.1: Add a new child Terraform module for provisioning an RDS database. Maintain the same setup principles as used for the EKS deployment:

Use a consistent folder structure, naming the folder rds-postgres-module.

Utilize variables and locals throughout the module. Avoid hardcoding values except for static items (e.g., setting Security Group outbound rules to 0.0.0.0/0).

Task #2.2: Configure the RDS database with the following specifications:

Use the Postgres engine.

Select major version 16.0, and choose the latest minor version available.

Set the instance type to db.t3.micro to remain within the AWS free tier limits.

Specify backup_retention_period as 7 days (acceptable range is 0 to 35 days).

Set the identifier to reviews-app-db. This identifier is the name of the RDS instance; if omitted, Terraform will assign a random, unique identifier.

Ensure a database called reviews-app-data is created within the DB instance when it’s launched

Include the manage_master_user_password attribute to enable managing the master password with AWS Secrets Manager.

Deploy the database in the same VPC as the EKS cluster (the VPC in your personal AWS account).

Determine additional settings based on your discretion, focusing on Terraform code quality rather than strict database setup best practices.

Task #2.3: Ensure the RDS instance is associated with a dedicated Security Group. This group should allow Postgres port access from the Security Group of the EKS worker nodes. Achieve this by:

Exporting the EKS worker nodes' Security Group ID using outputs in the EKS module.

Importing this Security Group ID into the RDS module using Terraform variables. The value for this variable should be sourced from the EKS module's output.

Task #2.4: Validate the connection to the RDS database:

Use kubectl exec to enter the nginx deployment pod created in Milestone #1.

Inside the pod, install the psql command-line tools.

Connect to the RDS database using the psql command. Provide the database endpoint, database name(not instance or cluster name), username, and password (retrieved from AWS Secrets Manager).

Once connected, execute a sample SQL query. For guidance, refer to this SQL tutorial for creating an HR database: SQL Sample Database Tutorial (Ссылки на внешний сайт.).
