# terraform/oidc-setup/github-oidc-role.tf

resource "aws_iam_role" "github_actions_bootstrap" {
  name = "GitHubActionsBootstrapRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            # restrict to your repo
            "token.actions.githubusercontent.com:sub" = "repo:codest40/terra:*"
          }
        }
      }
    ]
  })
}
