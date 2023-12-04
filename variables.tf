variable "region" {
  type    = string
  default = "us-east-1"
}

variable "A-Z-1" {
  type    = string
  default = "us-east-1a"
}

variable "A-Z-2" {
  type    = string
  default = "us-east-1b"
}

variable "A-Z-3" {
  type    = string
  default = "us-east-1c"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "vpc_20230512"
}

variable "igw_name_1" {
  type    = string
  default = "my_igw_name_1"
}

variable "my_public_subnet1_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}
variable "my_public_subnet1_name" {
  type    = string
  default = "public_subnet1"
}

variable "my_public_subnet2_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}
variable "my_public_subnet2_name" {
  type    = string
  default = "public_subnet2"
}

variable "my_public_subnet3_cidr_block" {
  type    = string
  default = "10.0.3.0/24"
}
variable "my_public_subnet3_name" {
  type    = string
  default = "public_subnet3"
}

variable "my_private_subnet1_cidr_block" {
  type    = string
  default = "10.0.4.0/24"
}
variable "my_private_subnet1_name" {
  type    = string
  default = "private_subnet1"
}

variable "my_private_subnet2_cidr_block" {
  type    = string
  default = "10.0.5.0/24"
}
variable "my_private_subnet2_name" {
  type    = string
  default = "private_subnet2"
}

variable "my_private_subnet3_cidr_block" {
  type    = string
  default = "10.0.6.0/24"
}
variable "my_private_subnet3_name" {
  type    = string
  default = "private_subnet3"
}


variable "public-rt-1" {
  type    = string
  default = "tf-public-rt-1"
}

variable "user_data_for_instance" {
  description = "User data script to run on the EC2 instance"
  default     = <<-EOT
    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    systemctl enable httpd
    systemctl start httpd
    cd /var/www/html
    echo ?Hello World from $(hostname -f)? > index.html
  EOT
}

variable "SNS_email" {
  type    = string
  default = "luyuanzhangcloud@gmail.com"
}

variable "hosted_zone_id" {
  type    = string
  default = "Z0291806IW30DPSWFZOV"
}

variable "domain_name" {
  type    = string
  default = "thezhangagency.com"
}

variable "database_username" {
  type    = string
  default = "luyuanzhang"
}

variable "database_pswd" {
  type    = string
  default = "LuyuanZhang12345"
}

variable "S3_storage_bucket" {
  type    = string
  default = "s3-central-storange-luyuanzhang"
}
