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