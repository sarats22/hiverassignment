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

resource "aws_security_group" "prod-web-servers-sg" {
  name        = "prod-web-servers-sg"
  description = "Allow inbound traffic"
  vpc_id      = "vpc-f4441c8e"

  ingress {
    description      = "Allow inbound traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  ingress {
    description      = "Allow inbound traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  resource "aws_instance" "app_server1" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"

  tags = {
    Name = "prodec2app1"
  }


resource "aws_instance" "app_server2" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"

  tags = {
    Name = "prodec21pp2"
  }

}


resource "aws_lb" "nwlb" {
  name               = "nwlb"
  internal           = false
  load_balancer_type = "network"
  cross_zone_load_balancing = true

 listener {
instance_port = 80
instance_protocol = “http”
lb_port = 80
lb_protocol = “http”
}
health_check {
healthy_threshold = 2
unhealthy_threshold = 2
timeout = 3
target = “HTTP:80/”
interval = 30
}

  availability_zones = [“${data.aws_availability_zones.allzones.names}"]
  instances = ["${aws_instance.app_server1.id}","${aws_instance.app_server2.id}"]
  subnets            = ["subnet-2071ad6d"]
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
