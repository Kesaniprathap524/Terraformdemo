resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "aws_key_pair" "key-pair" {
    key_name = "mykey"
    public_key = tls_private_key.private-key.public_key_openssh
}
resource "local_file" "file_name" {
    filename = "myfilename"
    content = tls_private_key.private-key.private_key_pem
}

resource "aws_instance" "public" {
  ami = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.my-sg.id]
  key_name = aws_key_pair.key-pair.key_name
  tags = {
    Name = "my-public-vm"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = tls_private_key.private-key.private_key_pem
  }
  provisioner "file" {
     source = "myfilename"
    destination = "/home/ec2-user"
  }

}

resource "aws_instance" "private" {
  ami = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  security_groups = [aws_security_group.my-sg.id]
  key_name = aws_key_pair.key-pair.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "my-private-vm"
  }
}
output "private_ip" {
  value = aws_instance.private.private_ip
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "demo"
  role = aws_iam_role.my-s3-role.id
}
