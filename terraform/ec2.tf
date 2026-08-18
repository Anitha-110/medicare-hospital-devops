# ==================================================
# EC2 LAUNCH TEMPLATE
# ==================================================

resource "aws_launch_template" "hospital_app" {
  name_prefix   = "hospital-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    yum update -y

    yum install -y python3

    pip3 install flask

    mkdir -p /opt/hospital-app

    cat > /opt/hospital-app/app.py <<'PYTHON'
    from flask import Flask

    app = Flask(__name__)

    @app.route("/")
    def home():
        return "Hospital Appointment Application is Running"

    @app.route("/health")
    def health():
        return "OK"

    app.run(host="0.0.0.0", port=5000)
    PYTHON

    nohup python3 /opt/hospital-app/app.py \
      > /var/log/hospital-app.log 2>&1 &

  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "hospital-app-server"
      Project = "Hospital-Appointment"
    }
  }
}


# ==================================================
# AUTO SCALING GROUP
# ==================================================

resource "aws_autoscaling_group" "hospital_asg" {
  name = "hospital-app-asg"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = [
    aws_subnet.private_app_subnet_a.id,
    aws_subnet.private_app_subnet_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.hospital_app_tg.arn
  ]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.hospital_app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "hospital-app-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "Hospital-Appointment"
    propagate_at_launch = true
  }
}
