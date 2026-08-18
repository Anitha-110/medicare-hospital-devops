# ==================================================
# RDS DB SUBNET GROUP
# ==================================================

resource "aws_db_subnet_group" "hospital_db_subnet_group" {
  name = "hospital-appointment-db-subnet"

  subnet_ids = [
    aws_subnet.private_db_subnet_a.id,
    aws_subnet.private_db_subnet_b.id
  ]

  tags = {
    Name    = "hospital-appointment-db-subnet"
    Project = "Hospital-Appointment"
  }
}


# ==================================================
# RDS MYSQL DATABASE
# ==================================================

resource "aws_db_instance" "hospital_db" {
  identifier = "hospital-appointment-db"

  # Database engine
  engine         = "mysql"
  engine_version = "8.0"

  # Instance
  instance_class = "db.t3.micro"

  # Storage
  allocated_storage = 20
  storage_type      = "gp3"

  # Database credentials
  db_name  = "hospitaldb"
  username = "admin"
  password = "******"

  # MySQL port
  port = 3306

  # DB subnet group
  db_subnet_group_name = aws_db_subnet_group.hospital_db_subnet_group.name

  # Existing RDS security group
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  # Private RDS
  publicly_accessible = false

  # Single-AZ for this project
  multi_az = false

  # Backup
  backup_retention_period = 7

  # Terraform destroy behavior
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name    = "hospital-rds"
    Project = "Hospital-Appointment"
  }
}
