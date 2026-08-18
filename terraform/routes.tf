# ==================================================
# PUBLIC ROUTE TABLE
# ==================================================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hospital_vpc.id

  tags = {
    Name = "hospital-public-rt"
  }
}


# ==================================================
# PUBLIC ROUTE TO INTERNET GATEWAY
# ==================================================

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hospital_igw.id
}


# ==================================================
# PUBLIC SUBNET A ASSOCIATION
# ==================================================

resource "aws_route_table_association" "public_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}


# ==================================================
# PUBLIC SUBNET B ASSOCIATION
# ==================================================

resource "aws_route_table_association" "public_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}


# ==================================================
# PRIVATE ROUTE TABLE - AZ A
# ==================================================

resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.hospital_vpc.id

  tags = {
    Name = "hospital-private-rt-a"
    AZ   = "ap-south-1a"
  }
}


# ==================================================
# PRIVATE ROUTE TO NAT GATEWAY A
# ==================================================

resource "aws_route" "private_nat_route_a" {
  route_table_id         = aws_route_table.private_rt_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id
}


# ==================================================
# PRIVATE APP SUBNET A ASSOCIATION
# ==================================================

resource "aws_route_table_association" "private_app_a_association" {
  subnet_id      = aws_subnet.private_app_subnet_a.id
  route_table_id = aws_route_table.private_rt_a.id
}


# ==================================================
# PRIVATE DB SUBNET A ASSOCIATION
# ==================================================

resource "aws_route_table_association" "private_db_a_association" {
  subnet_id      = aws_subnet.private_db_subnet_a.id
  route_table_id = aws_route_table.private_rt_a.id
}


# ==================================================
# PRIVATE ROUTE TABLE - AZ B
# ==================================================

resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.hospital_vpc.id

  tags = {
    Name = "hospital-private-rt-b"
    AZ   = "ap-south-1b"
  }
}


# ==================================================
# PRIVATE ROUTE TO NAT GATEWAY B
# ==================================================

resource "aws_route" "private_nat_route_b" {
  route_table_id         = aws_route_table.private_rt_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_b.id
}


# ==================================================
# PRIVATE APP SUBNET B ASSOCIATION
# ==================================================

resource "aws_route_table_association" "private_app_b_association" {
  subnet_id      = aws_subnet.private_app_subnet_b.id
  route_table_id = aws_route_table.private_rt_b.id
}


# ==================================================
# PRIVATE DB SUBNET B ASSOCIATION
# ==================================================

resource "aws_route_table_association" "private_db_b_association" {
  subnet_id      = aws_subnet.private_db_subnet_b.id
  route_table_id = aws_route_table.private_rt_b.id
}
