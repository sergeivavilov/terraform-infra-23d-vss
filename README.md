[![Terraform Deployment Workflow](https://github.com/312school/terraform-infra-23d-vss/actions/workflows/terraform-deploy.yaml/badge.svg)](https://github.com/312school/terraform-infra-23d-vss/actions/workflows/terraform-deploy.yaml)
# 312school / terraform-infra-23d


.github/workflows/terraform-deploy.yaml

# Role_ARN is in secrets

name: Terraform Deployment Workflow

on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: ["*"]

  # Allows you to run this workflow manually from the Actions tab
  # workflow_dispatch:

permissions:
  id-token: write # This is required for requesting the JWT
  contents: read  # This is required for actions/checkout

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  deploy:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest
    # Select environment based on branch pushed
    environment: ${{ (github.ref == 'refs/heads/main' && 'dev') || (github.ref == 'refs/heads/prod' && 'production') }}
    # default settings to apply for all the steps

    steps:
      - name: test IAM
        run: echo ${{ vars.AWS_ROLE_ARN }}
      - name: AWS Loggin
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: ${{ vars.AWS_IAM_ROLE }}
          role-session-name: githubactionsbot 
          aws-region: "us-east-1"
      
      - name: clone repo 
        uses: actions/checkout@v4

      - name: initialize Terraform
        run: terraform init 
        working-directory: ./root/main-eks-root

      - name: Plan execution
        run: terraform plan
        working-directory: ./root/main-eks-root

      - name: execute terraform
        run: terraform apply -auto-approve
        working-directory: ./root/main-eks-root
