resource "aws_vpc" "hospital_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "hospital-vpc"
    Environment = "Production"
    Project     = "Hospital-Appointment"
  }
}

resource "aws_internet_gateway" "hospital_igw" {
  vpc_id = aws_vpc.hospital_vpc.id

  tags = {
    Name    = "hospital-igw"
    Project = "Hospital-Appointment"
  }
}
