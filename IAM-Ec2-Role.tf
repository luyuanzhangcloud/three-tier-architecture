#create an EC2 role
resource "aws_iam_role" "EC2-to-S3_role" {
  name = "EC2-Full-Access-to-S3-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#attach a S3 full access policy to this role
resource "aws_iam_policy_attachment" "EC2toS3_policy_attachment" {
  name       = "EC2toS3_policy-attachment"
  roles      = [aws_iam_role.EC2-to-S3_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


#create IAM policy that allows EC2 full access to a specific bucket
resource "aws_iam_policy" "central_storage_S3_policy" {
  name        = "central_storage_S3_policy"
  description = "Policy for accessing a specific S3 bucket"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:*",
          "Resource" : aws_s3_bucket.central-storage-s3-storage.arn
        }
      ]
  })
}

#attach the above policy to the iam role
resource "aws_iam_role_policy_attachment" "S3_policy_attachment" {
  role       = aws_iam_role.EC2-to-S3_role.name
  policy_arn = aws_iam_policy.central_storage_S3_policy.arn
}

#create an instance profile for this EC2 role, to be attached to the launch template
resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.EC2-to-S3_role.name
}

#create EC2 role for RDS
resource "aws_iam_role" "ec2_mysql_role" {
  name = "ec2-mysql-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_mysql_policy" {
  name        = "ec2-mysql-policy"
  description = "Allows EC2 instances to access MySQL database"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "rds-db:connect",
        "Resource" : aws_rds_cluster.mysql_cluster.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_mysql_policy_attachment" {
  role       = aws_iam_role.ec2_mysql_role.name
  policy_arn = aws_iam_policy.ec2_mysql_policy.arn
}
