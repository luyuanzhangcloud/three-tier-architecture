resource "aws_security_group" "load_balancer" {
  name        = "application-load-balancer"
  description = "allow http access from anywhere"
  vpc_id      = aws_vpc.my_vpc_resource.id

  ingress {
    description = "allow inbound http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "allow-ssh-anywhere" {
  name        = "allow-ssh-anywhere"
  description = "allow ssh access from anywhere"
  vpc_id      = aws_vpc.my_vpc_resource.id

  ingress {
    description = "allow inbound ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_anywhere"
  }
}

resource "aws_security_group" "allow-http-anywhere" {
  name        = "allow-http-anywhere"
  description = "allow http access from anywhere"
  vpc_id      = aws_vpc.my_vpc_resource.id

  ingress {
    description = "allow inbound http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_anywhere"
  }
}