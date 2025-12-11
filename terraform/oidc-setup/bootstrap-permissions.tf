#terraform/oidc-setup/bootstrap-permissions.tf *

resource "aws_iam_role_policy" "bootstrap_permissions" {
  role = aws_iam_role.github_actions_bootstrap.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:*",
          "dynamodb:*"
        ],
        Resource = "*"
      }
    ]
  })
}
