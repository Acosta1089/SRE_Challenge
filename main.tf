terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

   required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"

}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.10.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

}

resource "aws_network_interface" "my_network" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["10.10.0.100"]

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "web_server" {
  ami           = "ami-0f9fc25dd2506cf6d"
  instance_type = var.ec2_instance_type
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.security_group.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  systemctl start httpd
  systemctl enable httpd
  echo '<html>' >> /var/www/html/index.html
  echo '<head>' >> /var/www/html/index.html
  echo '<title>Hello World</title>' >> /var/www/html/index.html
  echo '</head>' >> /var/www/html/index.html
  echo '<body>' >> /var/www/html/index.html
  echo '<h1>Hello World!</h1>' >> /var/www/html/index.html
  echo '</body>' >> /var/www/html/index.html
  echo '</html>' >> /var/www/html/index.html
  EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "security_group" {
  name        = "http_ssh_traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

