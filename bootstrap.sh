#!/bin/bash

cd terraform/oidc-setup

export AWS_ACCESS_KEY_ID=YOUR_TEMP_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_TEMP_SECRET
export AWS_REGION=us-east-1

terraform init
terraform apply -auto-approve

ROLE_ARN=$(terraform output -raw github_actions_bootstrap_role_arn)

# Update GitHub workflow
sed -i "s|role-to-assume:.*|role-to-assume: $ROLE_ARN|" ../../.github/workflows/bootstrap.yml

echo "Updated bootstrap.yml with new role ARN: $ROLE_ARN"
