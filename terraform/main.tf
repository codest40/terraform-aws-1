# main.tf


# -------------------------------
# 2️⃣ ECS Cluster
# -------------------------------
resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-cluster"
}

# -------------------------------
# 3️⃣ ECR Repository
# -------------------------------
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.app_name}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

# -------------------------------
# 4️⃣ IAM Role for ECS tasks
# -------------------------------
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.app_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
