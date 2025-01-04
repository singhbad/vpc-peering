# # S3 Bucket for Backend
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "singhbad"

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# VPCs
resource "aws_vpc" "vpcs" {
  for_each = var.vpc_cidrs

  cidr_block           = each.value
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${each.key}-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnets" {
  for_each = var.vpc_cidrs

  vpc_id            = aws_vpc.vpcs[each.key].id
  cidr_block        = cidrsubnet(each.value, 8, 1)
  availability_zone = var.availability_zones[each.key]
  map_public_ip_on_launch = var.enable_public_ip

  tags = {
    Name = "${each.key}-subnet"
  }
}

# Internet Gateways
resource "aws_internet_gateway" "igws" {
  for_each = aws_vpc.vpcs

  vpc_id = each.value.id

  tags = {
    Name = "${each.key}-igw"
  }
}

# Route Tables
resource "aws_route_table" "route_tables" {
  for_each = aws_vpc.vpcs

  vpc_id = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igws[each.key].id
  }

  tags = {
    Name = "${each.key}-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "rt_assoc" {
  for_each = aws_subnet.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_tables[each.key].id
}

# VPC Peering Connections
resource "aws_vpc_peering_connection" "web_to_db" {
  peer_vpc_id = aws_vpc.vpcs["db"].id
  vpc_id      = aws_vpc.vpcs["web"].id
  auto_accept = true

  tags = {
    Name = "web-to-db-peering"
  }
}

resource "aws_vpc_peering_connection" "app_to_db" {
  peer_vpc_id = aws_vpc.vpcs["db"].id
  vpc_id      = aws_vpc.vpcs["app"].id
  auto_accept = true

  tags = {
    Name = "app-to-db-peering"
  }
}

## Routes for VPC peering - Updated with all necessary routes
# Web to DB routes
resource "aws_route" "web_to_db" {
  route_table_id            = aws_route_table.route_tables["web"].id
  destination_cidr_block    = var.vpc_cidrs["db"]
  vpc_peering_connection_id = aws_vpc_peering_connection.web_to_db.id
}

resource "aws_route" "db_to_web" {
  route_table_id            = aws_route_table.route_tables["db"].id
  destination_cidr_block    = var.vpc_cidrs["web"]
  vpc_peering_connection_id = aws_vpc_peering_connection.web_to_db.id
}

# App to DB routes
resource "aws_route" "app_to_db" {
  route_table_id            = aws_route_table.route_tables["app"].id
  destination_cidr_block    = var.vpc_cidrs["db"]
  vpc_peering_connection_id = aws_vpc_peering_connection.app_to_db.id
}

resource "aws_route" "db_to_app" {
  route_table_id            = aws_route_table.route_tables["db"].id
  destination_cidr_block    = var.vpc_cidrs["app"]
  vpc_peering_connection_id = aws_vpc_peering_connection.app_to_db.id
}

# Security Groups - Updated with explicit CIDR blocks
resource "aws_security_group" "instance_sg" {
  for_each = aws_vpc.vpcs

  name        = "${each.key}-sg"
  description = "Security group for ${each.key} instance"
  vpc_id      = each.value.id

  # Allow ICMP (ping) from all VPCs
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.vpc_cidrs)  # This allows ping from all VPC CIDR ranges
  }

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${each.key}-sg"
  }
}

# EC2 Instances
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "instances" {
  for_each = aws_vpc.vpcs

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[each.key].id
  associate_public_ip_address = var.enable_public_ip
  vpc_security_group_ids = [aws_security_group.instance_sg[each.key].id]

  tags = {
    Name = "${each.key}-instance"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")  
}