#  ALB 
resource "aws_lb" "patient-appointment_alb" {
  name               = "Patient-Appointment-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
}

# Patient Service ALB Resources
resource "aws_lb_target_group" "patient_service" {
  name        = "patientsss-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener_rule" "patient_service" {
  listener_arn = aws_lb_listener.patient-appointment_alb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient_service.arn
  }

  condition {
    path_pattern {
      values = ["/patient*"]
    }
  }
}

#  Appointment ALB Resources
resource "aws_lb_target_group" "appointment_service" {
  name        = "appointmentsss-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener_rule" "appointment_service" {
  listener_arn = aws_lb_listener.patient-appointment_alb.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appointment_service.arn
  }

  condition {
    path_pattern {
      values = ["/appointment*"]
    }
  }
}

# ALB Listener 
resource "aws_lb_listener" "patient-appointment_alb" {
  load_balancer_arn = aws_lb.patient-appointment_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page Not Found"
      status_code  = "404"
    }
  }
}