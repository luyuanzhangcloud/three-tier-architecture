# create an EC2 instance in the public subnet, in case I need to ssh into my instances in the private subnets.
resource "aws_instance" "my-tf-instance-public" {
  ami                         = "ami-0889a44b331db0194"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  availability_zone           = var.A-Z-1
  security_groups             = [aws_security_group.allow-http-anywhere.id, aws_security_group.allow-ssh-anywhere.id]
  subnet_id                   = aws_subnet.my_public_subnet1.id
  key_name                    = aws_key_pair.my-tf-keypair.key_name
  user_data                   = base64encode(var.user_data_for_instance)

  tags = {
    Name = "public-instance-1"
  }
}
