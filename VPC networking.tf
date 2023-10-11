# you should create a S3 bucket in the region for this VPC before initializing terraform
#1. create a VPC
resource "aws_vpc" "my_vpc_resource" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

#2. create an internet gateway
resource "aws_internet_gateway" "my_igw_1" {
  vpc_id = aws_vpc.my_vpc_resource.id

  tags = {
    Name = var.igw_name_1
  }
}
#3. create 3 public subnets
resource "aws_subnet" "my_public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_public_subnet1_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.A-Z-1
  tags = {
    Name = var.my_public_subnet1_name
  }
}

resource "aws_subnet" "my_public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_public_subnet2_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.A-Z-2
  tags = {
    Name = var.my_public_subnet2_name
  }
}

resource "aws_subnet" "my_public_subnet3" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_public_subnet3_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.A-Z-3
  tags = {
    Name = var.my_public_subnet3_name
  }
}

#4. create 1st private subnet
resource "aws_subnet" "my_private_subnet1" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_private_subnet1_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.A-Z-1
  tags = {
    Name = var.my_private_subnet1_name
  }
}

#5. create 2nd private subnet
resource "aws_subnet" "my_private_subnet2" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_private_subnet2_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.A-Z-2
  tags = {
    Name = var.my_private_subnet2_name
  }
}

resource "aws_subnet" "my_private_subnet3" {
  vpc_id                  = aws_vpc.my_vpc_resource.id
  cidr_block              = var.my_private_subnet3_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.A-Z-3
  tags = {
    Name = var.my_private_subnet3_name
  }
}
#6. create a public route table1
resource "aws_route_table" "my-public-rt-1" {
  vpc_id = aws_vpc.my_vpc_resource.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw_1.id
  }
  tags = {
    Name = var.public-rt-1
  }
}

#7 associate the public route able1 with public subnets
resource "aws_route_table_association" "publicsubet1-rt-association1" {
  subnet_id      = aws_subnet.my_public_subnet1.id
  route_table_id = aws_route_table.my-public-rt-1.id
}

resource "aws_route_table_association" "publicsubet1-rt-association2" {
  subnet_id      = aws_subnet.my_public_subnet2.id
  route_table_id = aws_route_table.my-public-rt-1.id
}

resource "aws_route_table_association" "publicsubet1-rt-association3" {
  subnet_id      = aws_subnet.my_public_subnet3.id
  route_table_id = aws_route_table.my-public-rt-1.id
}

# Create NAT gateways in public subnets
resource "aws_nat_gateway" "my-NAT-gateway1" {
  allocation_id = aws_eip.NAT-gateway-EIP1.id
  subnet_id     = aws_subnet.my_public_subnet1.id
}

resource "aws_nat_gateway" "my-NAT-gateway2" {
  allocation_id = aws_eip.NAT-gateway-EIP2.id
  subnet_id     = aws_subnet.my_public_subnet2.id
}

resource "aws_nat_gateway" "my-NAT-gateway3" {
  allocation_id = aws_eip.NAT-gateway-EIP3.id
  subnet_id     = aws_subnet.my_public_subnet3.id
}
# Create Elastic IP for the NAT gateways
resource "aws_eip" "NAT-gateway-EIP1" {
  vpc = true
}

resource "aws_eip" "NAT-gateway-EIP2" {
  vpc = true
}

resource "aws_eip" "NAT-gateway-EIP3" {
  vpc = true
}

# Update route table of private subnets
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.my_vpc_resource.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-NAT-gateway1.id
  }

  tags = {
    Name = "private-route-table1"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.my_vpc_resource.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-NAT-gateway2.id
  }

  tags = {
    Name = "private-route-table2"
  }
}

resource "aws_route_table" "private_route_table3" {
  vpc_id = aws_vpc.my_vpc_resource.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-NAT-gateway3.id
  }

  tags = {
    Name = "private-route-table3"
  }
}

# Associate private subnets with the route tables
resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.my_private_subnet1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.my_private_subnet2.id
  route_table_id = aws_route_table.private_route_table2.id
}

resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.my_private_subnet3.id
  route_table_id = aws_route_table.private_route_table3.id
}