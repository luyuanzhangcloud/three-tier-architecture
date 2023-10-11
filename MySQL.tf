resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.my_private_subnet1.id, aws_subnet.my_private_subnet2.id, aws_subnet.my_private_subnet3.id] # Replace with your subnet IDs
}

resource "aws_rds_cluster" "mysql_cluster" {
  cluster_identifier        = "mysql-cluster"
  engine                    = "mysql"
  allocated_storage         = 400
  engine_version            = "8.0.32"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io1"
  iops = 3000
  availability_zones        = [var.A-Z-1, var.A-Z-2, var.A-Z-3]
  database_name             = "mysql_db_cluster"
  master_username           = var.database_username
  master_password           = var.database_pswd
  apply_immediately         = true
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.mysql_sg.id]
  skip_final_snapshot       = true
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "Security group for MySQL database"
  vpc_id      = aws_vpc.my_vpc_resource.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = aws_launch_template.launch-template.security_group_names
  }
}

