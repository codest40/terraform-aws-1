# terraform/oidc-setup/outputs.tf 

output "github_actions_bootstrap_role_arn" {
  value = aws_iam_role.github_actions_bootstrap.arn
}
