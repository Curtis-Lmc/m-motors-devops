# ============================================================
# Zones de disponibilité
# ============================================================

data "aws_availability_zones" "available" {
  state = "available"
}

# ============================================================
# VPC principal M-Motors
# ============================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "m-motors-vpc"
  }
}

# ============================================================
# Internet Gateway
# ============================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "m-motors-igw"
  }
}

# ============================================================
# Subnets publics
# Futurs emplacements de l'ALB et des tâches ECS économiques.
# ============================================================

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "m-motors-public-${count.index + 1}"
    Type = "Public"
  }
}

# ============================================================
# Subnets privés isolés
# Futurs emplacements de la base RDS PostgreSQL.
# ============================================================

resource "aws_subnet" "private" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 11)
  map_public_ip_on_launch = false

  tags = {
    Name = "m-motors-private-${count.index + 1}"
    Type = "Private"
  }
}

# ============================================================
# Routage des subnets publics
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "m-motors-public-route-table"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# Routage des subnets privés
# Aucune route vers Internet n'est ajoutée.
# ============================================================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "m-motors-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}