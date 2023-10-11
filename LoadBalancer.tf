resource "aws_lb" "application_load_balancer" {
  name               = "application-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.my_public_subnet1.id, aws_subnet.my_public_subnet2.id]
  security_groups    = [aws_security_group.load_balancer.id]

  tags = {
    Name = "application-load-balancer"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

