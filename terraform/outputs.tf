output "aws_connection_verified" {
  description = "Confirme que Terraform est authentifié auprès d'AWS"
  value       = data.aws_caller_identity.current.account_id != ""
}

output "aws_region" {
  description = "Région AWS utilisée par Terraform"
  value       = var.aws_region
}

output "frontend_bucket_name" {
  description = "Nom du bucket contenant le frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "documents_bucket_name" {
  description = "Nom du bucket privé contenant les dossiers clients"
  value       = aws_s3_bucket.documents.bucket
}

output "cloudfront_distribution_id" {
  description = "Identifiant de la distribution CloudFront"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "Nom de domaine généré par CloudFront"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_url" {
  description = "URL HTTPS publique du frontend M-Motors"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "vpc_id" {
  description = "Identifiant du VPC principal"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Identifiants des deux subnets publics"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Identifiants des deux subnets privés"
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "Zones de disponibilité utilisées"
  value       = aws_subnet.public[*].availability_zone
}

output "alb_security_group_id" {
  description = "Security Group du futur Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security Group des tâches ECS"
  value       = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  description = "Security Group de PostgreSQL RDS"
  value       = aws_security_group.rds.id
}

output "ecr_repository_url" {
  description = "Adresse du dépôt ECR contenant l'image FastAPI"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecs_execution_role_arn" {
  description = "ARN du rôle utilisé par ECS pour lancer les tâches"
  value       = aws_iam_role.ecs_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN du rôle utilisé par l'application FastAPI"
  value       = aws_iam_role.ecs_task.arn
}