#!/bin/bash

cd terraform/oidc-setup
dir="$(pwd)"
echo "Correct Working Dir: $dir"

echo "Testing Env Var Presence"
echo "AWS REGION: $AWS_REGION"

terraform init
terraform apply -auto-approve

ROLE_ARN=$(terraform output -raw github_actions_bootstrap_role_arn)

# Update GitHub workflow
sed -i "s|role-to-assume:.*|role-to-assume: $ROLE_ARN|" ../../.github/workflows/bootstrap.yml

echo "Updated bootstrap.yml with new role ARN: $ROLE_ARN"
