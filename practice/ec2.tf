resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  vpc_id      = aws_vpc.myvpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
  tags = {
    Name = "my-sg"
  }
}

