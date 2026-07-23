# Dépôt privé contenant l'image Docker du backend FastAPI.
resource "aws_ecr_repository" "backend" {
  name                 = "m-motors-api"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "m-motors-api"
  }
}