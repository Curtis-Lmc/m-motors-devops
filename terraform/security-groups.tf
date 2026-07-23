# ============================================================
# Security Group de l'Application Load Balancer
# ============================================================

resource "aws_security_group" "alb" {
  name_prefix = "m-motors-alb-"
  description = "Security group for the public Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "m-motors-alb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Le futur ALB acceptera les connexions HTTP publiques.
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow public HTTP traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

# Le Load Balancer pourra contacter uniquement ECS sur le port 8000.
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow traffic to ECS application"

  referenced_security_group_id = aws_security_group.ecs.id
  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
}

# ============================================================
# Security Group des tâches ECS Fargate
# ============================================================

resource "aws_security_group" "ecs" {
  name_prefix = "m-motors-ecs-"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "m-motors-ecs-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ECS accepte uniquement le trafic venant du Load Balancer.
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow application traffic from ALB"

  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
}

# ECS devra pouvoir récupérer l'image Docker et contacter les services AWS.
resource "aws_vpc_security_group_egress_rule" "ecs_all_ipv4" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow ECS outbound traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# ============================================================
# Security Group de PostgreSQL RDS
# ============================================================

resource "aws_security_group" "rds" {
  name_prefix = "m-motors-rds-"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "m-motors-rds-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# PostgreSQL accepte uniquement les connexions venant d'ECS.
resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow PostgreSQL traffic from ECS"

  referenced_security_group_id = aws_security_group.ecs.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}