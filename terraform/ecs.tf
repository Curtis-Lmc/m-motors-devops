# ============================================================
# Cluster ECS
# ============================================================

resource "aws_ecs_cluster" "main" {
  name = "m-motors-cluster"

  tags = {
    Name = "m-motors-cluster"
  }
}

# ============================================================
# Logs de l'application FastAPI
# ============================================================

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/m-motors-api"
  retention_in_days = 7

  tags = {
    Name = "m-motors-api-logs"
  }
}

# ============================================================
# Définition de tâche ECS Fargate
# Elle indique à ECS comment lancer notre conteneur.
# ============================================================

resource "aws_ecs_task_definition" "backend" {
  family                   = "m-motors-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "m-motors-api"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DOCUMENTS_BUCKET"
          value = aws_s3_bucket.documents.bucket
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "m-motors-api-task"
  }
}