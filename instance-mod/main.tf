data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route{
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}

resource "aws_route_table_association" "route-tbl-link1" {
  subnet_id = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}

resource "aws_key_pair" "mattias" {
  key_name   = "mattias-public-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQHde4y3bjidC7XpXOLwqe5TiXHFXgHYECe612cE32E9zn4JiBV3J7fKCLUxCVK3+jClJEQr263V75YQwD1giR3nhB9rkEAdXJra506hmSSxEn4Gm/KnzUc411RcCggcBNNbUGQ3FxM7M7cMkS4iFJb2erkVHFc1Gc4+nSBrSxCWbCTS6DQVm4hE3eFP7IGvwzbPPj6YtBIxpPzQvhkVgjZtY9IZbCCp+Z7ctcQkbb0ox6USJHJmIYDaGEBbqMAesfZHhnG0cGDDRRzl5Xk/yLA7wpb40Grt1tCucXsUdXdJpD2xxiBYPtyK1j7kkU4Me4rNAMBZA6MVBADjj85q2j mattias"
}

resource "aws_instance" "instance" {
  ami           = lookup(var.amis, data.aws_region.current.name)
  instance_type = "t3.micro"
  key_name = aws_key_pair.mattias.key_name
  associate_public_ip_address = true

  subnet_id = aws_subnet.main_subnet.id

  security_groups = [
    aws_security_group.allow_ssh.id
  ]

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
    Service = "Hello"
  }
}
