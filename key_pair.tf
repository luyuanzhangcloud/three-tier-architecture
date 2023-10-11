#generate a key pair and name it "key_formy_tf-vpc"
# use the resource tls_private_key to generate a key pair named "key_formy_tf_VPC"
resource "tls_private_key" "key_formy_tf-VPC" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "public_key_tf_VPC" {
  value = tls_private_key.key_formy_tf-VPC.public_key_openssh
}

#output "private_key_tf_VPC" {
#  value = tls_private_key.key_formy_tf-VPC.private_key_pem
#}


#create AWS key pairs from the public key generated from the above key pair, and name it my-tf-keypair
resource "aws_key_pair" "my-tf-keypair" {
  key_name   = formatdate("YYYYMMDD", timestamp())
  public_key = tls_private_key.key_formy_tf-VPC.public_key_openssh
}

resource "local_file" "output_file" {
  filename = join("", [aws_key_pair.my-tf-keypair.key_name, ".pem"])
  content  = tls_private_key.key_formy_tf-VPC.private_key_pem
}