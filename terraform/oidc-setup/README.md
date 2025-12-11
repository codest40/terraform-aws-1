✅ What this setup does

### Terraform OIDC setup (terraform/oidc-setup/)

oidc-provider.tf → Creates GitHub OIDC provider in AWS

github-oidc-role.tf → Creates IAM role GitHubActionsBootstrapRole that GitHub can assume

bootstrap-permissions.tf → Grants minimal S3 + DynamoDB permissions for Terraform bootstrap

outputs.tf → Outputs the role ARN

Bootstrap script (bootstrap.sh)

Runs Terraform locally with temporary AWS credentials

Gets the role ARN from Terraform output

Automatically updates .github/workflows/bootstrap.yml to insert the new role ARN

GitHub Actions workflow (.github/workflows/bootstrap.yml)

Uses OIDC to assume the IAM role (no AWS keys needed after first run)

Creates the S3 bucket + DynamoDB table for Terraform backend

Fully idempotent — can be triggered multiple times safely


Key points / Pros

First run: Needs temporary AWS keys (stored in environment and deleted after run, not GitHub)

Subsequent runs: GitHub Actions uses OIDC; no keys needed

Idempotent: Terraform will only create resources if they don’t exist

Secure: No AWS secrets stored in repo or workflow
