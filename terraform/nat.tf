# ==================================================
# ELASTIC IP FOR NAT GATEWAY - AZ A
# ==================================================

resource "aws_eip" "nat_eip_a" {
  domain = "vpc"

  tags = {
    Name = "hospital-nat-eip-a"
    AZ   = "ap-south-1a"
  }
}


# ==================================================
# ELASTIC IP FOR NAT GATEWAY - AZ B
# ==================================================

resource "aws_eip" "nat_eip_b" {
  domain = "vpc"

  tags = {
    Name = "hospital-nat-eip-b"
    AZ   = "ap-south-1b"
  }
}


# ==================================================
# NAT GATEWAY - AZ A
# ==================================================

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "hospital-nat-a"
    AZ   = "ap-south-1a"
  }

  depends_on = [
    aws_internet_gateway.hospital_igw
  ]
}


# ==================================================
# NAT GATEWAY - AZ B
# ==================================================

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "hospital-nat-b"
    AZ   = "ap-south-1b"
  }

  depends_on = [
    aws_internet_gateway.hospital_igw
  ]
}
