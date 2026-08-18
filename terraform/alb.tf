# ==================================================
# APPLICATION LOAD BALANCER
# ==================================================

resource "aws_lb" "hospital_alb" {
  name               = "hospital-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name    = "hospital-alb"
    Project = "Hospital-Appointment"
  }
}


# ==================================================
# TARGET GROUP
# ==================================================

resource "aws_lb_target_group" "hospital_app_tg" {
  name     = "hospital-app-tg"
  port     = 5000
  protocol = "HTTP"

  vpc_id = aws_vpc.hospital_vpc.id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "5000"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name    = "hospital-app-target-group"
    Project = "Hospital-Appointment"
  }
}


# ==================================================
# ALB LISTENER - HTTP
# ==================================================

resource "aws_lb_listener" "hospital_http" {
  load_balancer_arn = aws_lb.hospital_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hospital_app_tg.arn
  }
}
