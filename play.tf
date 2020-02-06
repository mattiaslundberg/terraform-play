data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  availability_zone = "eu-north-1a"

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_subnet" "cool_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  availability_zone = "eu-north-1b"

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_route_table_association" "route-tbl-link1" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}


resource "aws_key_pair" "mattias" {
  key_name   = "mattias-public-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyiSB9pScYyZmOJz/CQw5g4t4IHqY/XohQuzg/mWgPRgw8oBaV/AtLJ/Zk3uGhu4QJewS5S/QV9rmrLnt16w4t5Ow6jCrbK+MmuPQGDnXcNOn1WNm0vEj2sKXFZjsudwQqLxF7z/3RFebWXPkMe0gwcPJUwOjYBJUVyGIGljGWfibOSRXw4N9GS9Mq9Kvwj7H2j4WbBZROygjh74yLBTqKpjPdc3uWO5h29cnb3cr2830BTadM18SveqeBKB2obUqeIbkjD78KARJwnyuAFf1wXYh+aYj7O2wTlj6+h31Rz8iycZSzhs6lrtbrf8B4yxilw3iOqRQKH+q9sb0Gw7YJ mattias@mattias-XPS-13-9380"
}

# Ubuntu AMI: "ami-01d965b90792d9bf7"
resource "aws_instance" "instans" {
  ami           = "ami-01d965b90792d9bf7"
  instance_type = "t3.small"
  vpc_security_group_ids = [
    aws_security_group.allow_ssh_http.id
  ]
  subnet_id = element([aws_subnet.main_subnet.id, aws_subnet.cool_subnet.id], count.index)
  key_name = aws_key_pair.mattias.key_name
  count = 2

  tags = {
    Name       = "Mattias ${count.index}"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_lb" "cool_lb" {
  name               = "cool-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = [aws_subnet.main_subnet.id, aws_subnet.cool_subnet.id]

  tags = {
    Name       = "Mattias"
    Maintainer = "Mattias"
    Service    = "Hello"
  }
}

resource "aws_lb_target_group" "cool_tg" {
  name     = "cool-lb-tg-tf"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.cool_tg.arn
  count = 2
  target_id        = "${aws_instance.instans[count.index].id}"
  port             = 22
}
