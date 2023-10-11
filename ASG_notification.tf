resource "aws_sns_topic" "ASG_CPU" {
  name = "ASG_CPU"
}

resource "aws_sns_topic_subscription" "ASG_CPU_subscription" {
  topic_arn = aws_sns_topic.ASG_CPU.arn
  protocol  = "email"
  endpoint  = var.SNS_email
}

resource "aws_cloudwatch_metric_alarm" "CPU_utilization_alarm" {
  alarm_name          = "cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "CPU utilization exceeds 70%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  alarm_actions = [aws_sns_topic.ASG_CPU.arn]
}

resource "aws_sns_topic" "ASG_Launch_Termination" {
  name = "ASG_Launch_Termination"
}

resource "aws_sns_topic_subscription" "ASG_Launch_Termination_subscription" {
  topic_arn = aws_sns_topic.ASG_Launch_Termination.arn
  protocol  = "email"
  endpoint  = var.SNS_email
}

resource "aws_autoscaling_notification" "ASG_Launch_Termination_notification" {
  group_names = [aws_autoscaling_group.autoscaling_group.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
  ]

  topic_arn = aws_sns_topic.ASG_Launch_Termination.arn
}