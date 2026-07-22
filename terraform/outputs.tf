output "aws_connection_verified" {
  description = "Confirme que Terraform est authentifié auprès d'AWS"
  value       = data.aws_caller_identity.current.account_id != ""
}

output "aws_region" {
  description = "Région AWS utilisée par Terraform"
  value       = var.aws_region
}