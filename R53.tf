# I have a hosted zone and a registered domain named "thezhangagency.com"
resource "aws_route53_record" "Alias-ALB" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    evaluate_target_health = true
    zone_id                = aws_lb.application_load_balancer.zone_id
  }
}

