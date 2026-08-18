# ==================================================
# PUBLIC SUBNET - AVAILABILITY ZONE A
# ==================================================

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.hospital_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "hospital-public-a"
    Tier = "Public"
    AZ   = "ap-south-1a"
  }
}


# ==================================================
# PUBLIC SUBNET - AVAILABILITY ZONE B
# ==================================================

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.hospital_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "hospital-public-b"
    Tier = "Public"
    AZ   = "ap-south-1b"
  }
}


# ==================================================
# PRIVATE APPLICATION SUBNET - AZ A
# ==================================================

resource "aws_subnet" "private_app_subnet_a" {
  vpc_id            = aws_vpc.hospital_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "hospital-private-app-a"
    Tier = "Application"
    AZ   = "ap-south-1a"
  }
}


# ==================================================
# PRIVATE APPLICATION SUBNET - AZ B
# ==================================================

resource "aws_subnet" "private_app_subnet_b" {
  vpc_id            = aws_vpc.hospital_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "hospital-private-app-b"
    Tier = "Application"
    AZ   = "ap-south-1b"
  }
}


# ==================================================
# PRIVATE DATABASE SUBNET - AZ A
# ==================================================

resource "aws_subnet" "private_db_subnet_a" {
  vpc_id            = aws_vpc.hospital_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "hospital-private-db-a"
    Tier = "Database"
    AZ   = "ap-south-1a"
  }
}


# ==================================================
# PRIVATE DATABASE SUBNET - AZ B
# ==================================================

resource "aws_subnet" "private_db_subnet_b" {
  vpc_id            = aws_vpc.hospital_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "hospital-private-db-b"
    Tier = "Database"
    AZ   = "ap-south-1b"
  }
}
