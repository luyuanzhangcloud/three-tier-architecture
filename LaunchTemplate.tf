resource "aws_launch_template" "launch-template" {
  name_prefix   = "launch-template"
  image_id      = "ami-0889a44b331db0194"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.my-tf-keypair.key_name
  user_data     = base64encode(var.user_data_for_instance)
  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn

  }
  
  vpc_security_group_ids = [aws_security_group.load_balancer.id]
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }
}