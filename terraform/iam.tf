# ============================================================
# Politique de confiance commune aux rôles ECS
# ============================================================

data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# ============================================================
# Rôle d'exécution ECS
# Permet à Fargate de récupérer l'image ECR et d'envoyer les logs.
# ============================================================

resource "aws_iam_role" "ecs_execution" {
  name               = "m-motors-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ============================================================
# Rôle de la tâche ECS
# Utilisé directement par l'application FastAPI.
# ============================================================

resource "aws_iam_role" "ecs_task" {
  name               = "m-motors-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

# Autorisation minimale de lecture du bucket des dossiers clients.
data "aws_iam_policy_document" "ecs_documents_read" {
  statement {
    sid    = "ListDocumentsBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.documents.arn
    ]
  }

  statement {
    sid    = "ReadDocuments"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.documents.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_documents_read" {
  name   = "m-motors-read-documents"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_documents_read.json
}