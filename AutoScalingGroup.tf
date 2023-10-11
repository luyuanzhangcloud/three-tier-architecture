#create a ASG from a launch template; 
# EC2 instances from ASG has full access to a S3 bucket named: S3-central-storange-LuyuanZhang
resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "autoscaling-group"
  min_size                  = 3
  max_size                  = 5
  desired_capacity          = 3
  health_check_type         = "EC2"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.my_private_subnet1.id, aws_subnet.my_private_subnet2.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc_resource.id
  target_type = "instance"
}

resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  alb_target_group_arn   = aws_lb_target_group.target_group.arn
}

