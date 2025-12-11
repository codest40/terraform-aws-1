# Terraform Infrastructure Project (Simple Fargate + ECR)

## Project Overview

This project demonstrates a full Infrastructure-as-Code (IaC) setup using Terraform and GitHub Actions for deploying a simple AWS architecture:

- **Backend (Bootstrap):** Sets up Terraform state storage and OIDC IAM role for GitHub Actions.
- **Main Terraform:** Deploys ECS Fargate cluster, ECR repository, and IAM roles.
- **CI/CD Integration:** Fully automated workflows using GitHub Actions and secure OIDC authentication.

---

## Architecture Diagram

*(Insert diagram here if available)*

---

## Logical Separation

The project is organized into three distinct layers:

### 1. Bootstrap / Backend (`terraform/bootstrap/`)
- Creates S3 bucket and DynamoDB table for Terraform state.
- Provides persistent storage for infrastructure state.

### 2. OIDC Setup (`terraform/oidc-setup/`)
- Configures GitHub OIDC provider and IAM role.
- Enables GitHub Actions to authenticate with AWS without permanent credentials.

### 3. Main Terraform (`terraform/main.tf`)
- Deploys AWS resources: ECS cluster, ECR repository, ECS task IAM role.
- Uses the bootstrap backend for state management.
- Fully configurable via Terraform variables.

---

## CI/CD Integration

Two GitHub Actions workflows automate deployment:

### Bootstrap Workflow (`bootstrap.yml`)
- Triggered manually.
- Initializes Terraform bootstrap directory.
- Creates backend resources (S3 bucket, DynamoDB table).
- Uses OIDC role for secure AWS access.

### Main Terraform Workflow (`main-terraform.yml`)
- Triggered on pull requests and pushes to `main`.
- Performs Terraform `init`, `plan`, and `apply`.
- Applies only on main branch; plans run on PRs for review.
- Uses the bootstrap backend and OIDC role.

---

## Workflow Security

- No hard-coded AWS credentials; uses OIDC for token-based access.
- Secrets stored in AWS Secrets Manager via Ansible.
- Idempotent and safe to run multiple times.

---

## Scripts & Workflow

| Script                  | Purpose                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| `bootstrap.sh`          | Initializes and applies Terraform OIDC setup; updates GitHub workflow with the bootstrap role ARN automatically. |
| `ansible/secrets.yml`   | Reads `.env` and uploads sensitive variables to AWS Secrets Manager (Terraform, AWS credentials, app secrets). |
| `exporter.sh`           | Exports `.env` variables into local environment for use by other scripts. |
| `push.sh`               | Orchestrates the workflow: loads environment, uploads secrets via Ansible, pushes code to GitHub to trigger CI/CD. |

---

## Typical Deployment Flow

```bash
# Load environment variables
source ./exporter.sh

# Bootstrap AWS backend & OIDC
./bootstrap.sh

# Upload secrets to AWS
ansible-playbook ansible/secrets.yml

# Push to GitHub to trigger CI/CD
./push.sh


## Terraform Project Structure
terraform/
├── backend.tf                   # S3/DynamoDB backend for Terraform
├── main.tf                      # ECS cluster, ECR repo, IAM roles
├── variables.tf                 # Variables for main Terraform
├── outputs.tf                   # Terraform outputs
├── provider.tf                  # AWS provider configuration
├── bootstrap/
│   └── main.tf                  # Backend bootstrap (S3 + DynamoDB)
└── oidc-setup/
    ├── github-oidc-role.tf      # IAM role for GitHub Actions OIDC
    ├── bootstrap-permissions.tf # Policy attachment for bootstrap role
    ├── oidc-provider.tf         # OIDC provider
    └── outputs.tf               # Outputs bootstrap role ARN


Extensibility

Additional resources (e.g., RDS, S3 buckets, load balancers) can be added without breaking the backend.

IAM roles are modular; additional roles can be created for ECS tasks, Lambda, or other AWS services.

CI/CD workflow supports future scaling and complex deployments.
