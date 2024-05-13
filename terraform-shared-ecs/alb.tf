resource "aws_lb" "ecs_frontend" {
  name               = "${var.cluster_name}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.ecs_frontend.id]
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.ecs_frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ecs_frontend" {
  load_balancer_arn = aws_lb.ecs_frontend.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.ecs_frontend.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No service registered"
      status_code  = "404"
    }
  }

  depends_on = [aws_acm_certificate_validation.ecs_frontend]
}

resource "aws_security_group" "ecs_frontend" {
  name        = "${var.cluster_name}-ecs-alb-sg"
  description = "Security group for ECS frontend ALB"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.cluster_name}-ecs-alb-sg"
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each          = toset(["80", "443"])
  security_group_id = aws_security_group.ecs_frontend.id
  type              = "ingress"
  description       = "Inbound port ${each.value}"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

data "aws_route53_zone" "selected" {
  name = var.route53_zone_name
}

locals {
  dns_subdomain = "${var.cluster_name}.${data.aws_route53_zone.selected.name}"
}

resource "aws_route53_record" "ecs_frontend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "*.${local.dns_subdomain}"
  type    = "A"

  alias {
    name                   = aws_lb.ecs_frontend.dns_name
    zone_id                = aws_lb.ecs_frontend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "ecs_frontend" {
  domain_name       = aws_route53_record.ecs_frontend.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.ecs_frontend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "ecs_frontend" {
  certificate_arn         = aws_acm_certificate.ecs_frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
