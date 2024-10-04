provider "aws" {
    region = "ca-central-1"
}

resource "aws_vpc" "saivpc" {
  cidr_block = "10.10.9.0/24"
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "adityavpc"
  }
}

resource "aws_internet_gateway" "saiIgw" {
  vpc_id = aws_vpc.saivpc.id
  tags = {
    Name = "adityaIGW"
  }
}

resource "aws_subnet" "saipublicsubnet1" {
  vpc_id = aws_vpc.saivpc.id
  cidr_block = "10.10.9.0/26"
  availability_zone = "ca-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "adityapub1"
  }
}

resource "aws_subnet" "saipublicsubnet2" {
  vpc_id = aws_vpc.saivpc.id
  cidr_block = "10.10.9.64/26"
  availability_zone = "ca-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "adityapub2"
  }
}

resource "aws_subnet" "saiprivatesubnet1" {
  vpc_id = aws_vpc.saivpc.id
  cidr_block = "10.10.9.128/26"
  availability_zone = "ca-central-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "adityaprivate1"
  }
}

resource "aws_subnet" "saiprivatesubnet2" {
  vpc_id = aws_vpc.saivpc.id
  cidr_block = "10.10.9.192/26"
  availability_zone = "ca-central-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "adityaprivate2"
  }
}

resource "aws_route_table" "saipubRT" {
  vpc_id = aws_vpc.saivpc.id
  tags = {
    Name = "adityart"
  }
}

resource "aws_route" "PubRTIGW" {
  route_table_id = aws_route_table.saipubRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.saiIgw.id
}

resource "aws_route_table_association" "pub1_association" {
  subnet_id = aws_subnet.saipublicsubnet1.id
  route_table_id = aws_route_table.saipubRT.id
}

resource "aws_route_table_association" "pub2_association" {
  subnet_id = aws_subnet.saipublicsubnet2.id
  route_table_id = aws_route_table.saipubRT.id
}

resource "aws_route_table" "saipvtRT" {
  vpc_id = aws_vpc.saivpc.id
  tags = {
    Name = "adityapvtrt"
  }
}

resource "aws_route_table_association" "pvt1_association" {
  subnet_id = aws_subnet.saiprivatesubnet1.id
  route_table_id = aws_route_table.saipvtRT.id
}

resource "aws_route_table_association" "pvt2_association" {
  subnet_id = aws_subnet.saiprivatesubnet2.id
  route_table_id = aws_route_table.saipvtRT.id
}

resource "aws_security_group" "saisg" {
  name        = "saisg"
  description = "Allow https,http,ssh"
  vpc_id      = aws_vpc.saivpc.id

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "saisg"
  }
}
