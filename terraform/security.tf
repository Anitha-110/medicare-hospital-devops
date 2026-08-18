# ==================================================
# ALB SECURITY GROUP
# ==================================================

resource "aws_security_group" "alb_sg" {
  name        = "hospital-alb-sg"
  description = "Security group for Hospital Application Load Balancer"
  vpc_id      = aws_vpc.hospital_vpc.id

  # HTTP from Internet
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS from Internet
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "hospital-alb-sg"
    Project = "Hospital-Appointment"
  }
}


# ==================================================
# APPLICATION SECURITY GROUP
# ==================================================

resource "aws_security_group" "app_sg" {
  name        = "hospital-app-sg"
  description = "Security group for Hospital Application EC2"
  vpc_id      = aws_vpc.hospital_vpc.id

  # Application traffic ONLY from ALB
  ingress {
    description     = "Application traffic from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # SSH for administration
  # We will secure SSH properly later using SSM.
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "hospital-app-sg"
    Project = "Hospital-Appointment"
  }
}


# ==================================================
# RDS SECURITY GROUP
# ==================================================

resource "aws_security_group" "rds_sg" {
  name        = "hospital-rds-sg"
  description = "Security group for Hospital RDS"
  vpc_id      = aws_vpc.hospital_vpc.id

  # MySQL ONLY from application servers
  ingress {
    description     = "MySQL from Application EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "hospital-rds-sg"
    Project = "Hospital-Appointment"
  }
}
