resource "aws_vpc" "myvpc" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "My_vpc"
    }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.myvpc.id  
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.1.2.0/24"
  tags = {
    Name = "Private"
  }
}

resource "aws_internet_gateway" "my_ig" {
    vpc_id = aws_vpc.myvpc.id   
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "public_rta" {
    route_table_id = aws_route_table.rt-public.id
    subnet_id = aws_subnet.public.id
}

resource "aws_route_table_association" "private_rta" {
    route_table_id = aws_route_table.rt-private.id
    subnet_id = aws_subnet.private.id
}


resource "aws_vpc_endpoint" "s3-endpoint" {
    service_name = "com.amazonaws.us-east-1.s3"
    vpc_id = aws_vpc.myvpc.id
    route_table_ids = [aws_route_table.rt-private.id]
    vpc_endpoint_type = "Gateway"
    tags = {
        Name = "my-endpoint"
    }
}

resource "aws_vpc_endpoint" "s3-endpoint-interface" {
    service_name = "com.amazonaws.us-east-1.s3"
    vpc_id = aws_vpc.myvpc.id
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [aws_security_group.my-sg.id]
    subnet_ids = [aws_subnet.private.id]
    
    tags = {
        Name = "my-endpoint-interface"
    }
}


   

