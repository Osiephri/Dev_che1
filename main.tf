terraform {
  required_providers {
    aws = {
      version = "~>3.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-south-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-one"
    key            = ""
    region         = "eu-south-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}
resource "aws_key_pair" "ansible_key" {
  key_name="ansiblekey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/MbZS38AAlAq2n4P0WVp8tCq6NI0/CeZGJCDCxOveZLD/5rue1cVzIKKlHjXlqO3VU3NmV//pnGqbOc8beZ90x7WCY/yOXoyt7z1JhynDHB7fD7XVHCv05GIcaEyBalBnHnqf6EPG0wkWQZ/2oEuaA1zZrw7z5GceCluZy21wUgMDpjcclGXyydnAC9HF2E0/KqOA+l8tLgvN5DcVCRLEnHv4H0t2Bz0k/ayxJQiGzSOro0u3PJVUo5TceShO5cWMKt0PG5SRLujb+I1HaoB910WaEWP5r68EjlCtrpZKeTnM5xtL2u+dEIsZT5XRYmVaBcBCJ7YiVU14SapqlCD3ami6Y3KSPhZ1MyZmZIBDyC/wSZ6FPYTzJUwtKlnz8an4J3a8LnUtu1yJUCp3dHuKZOdtQQQqNKG0HPH/0ADMgwEp9x/2xdb8ezHV78qpQBwRuCx62ZNTCP0vmrbw+u8Tuooh/EitJmmeWAOVve6kYuhd6xdg3tnaGRbyTlRuL+E= ELITEBOOK 2560p@OBUS"
}

resource "aws_instance" "instance_1" {
  ami             = "ami-0024dc61bc2f3d60f" # Amazon Linux 2 20.04 LTS // eu-south-1
  instance_type   = "t3.small"
  security_groups = [aws_security_group.instances.name]
  key_name = aws_key_pair.ansible_key.key_name
  aws_db_instance = aws_db_instance.db_instance.name
  user_data       = <<-EOF
               #!/bin/bash
              #sudo su -
              sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install -y nodejs
              sudo amazon-linux-extras list | grep nginx
              sudo amazon-linux-extras enable nginx1
              sudo yum clean metadata
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              sudo cd ./ sudo cd /home/ec2-user/jumia_phone_validator/validator-frontend && npm install
              sudo npm install serve -g 
              sudo npm run build
              sudo serve -s -l 8081
              #sudo cat ./build >> usr/share/nginx/html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "instance_2" {
  ami             = "ami-0024dc61bc2f3d60f"
  instance_type   = "t3.small"
  security_groups = [aws_security_group.instances.name]
  key_name = aws_key_pair.ansible_key.key_name
  aws_db_instance = aws_db_instance.db_instance.name
  user_data       = <<-EOF
              #!/bin/bash
              #sudo su -
              sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install nodejs
              sudo amazon-linux-extras list | grep nginx
              sudo amazon-linux-extras enable nginx1
              sudo yum clean metadata
              sudo yum install -y nginx
              sudo systemctl enable nginx.service
              sudo systemctl start nginx.service
              sudo cd ./validator && npm install
              sudo npm install serve -g 
              sudo npm run build
              sudo serve -s -l 8081
              #sudo cat ./build >> usr/share/nginx/html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "instance_1" {
  ami             = "ami-0024dc61bc2f3d60f" # Amazon Linux 2 20.04 LTS // eu-south-1
  instance_type   = "t3.small"
  security_groups = [aws_security_group.instances.name]
  key_name = aws_key_pair.ansible_key.key_name
  aws_db_instance = aws_db_instance.db_instance.name
  user_data       = <<-EOF
               #!/bin/bash
              #sudo su -
              sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install -y nodejs
              sudo amazon-linux-extras list | grep nginx
              sudo amazon-linux-extras enable nginx1
              sudo yum clean metadata
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              sudo cd ./ sudo cd /home/ec2-user/jumia_phone_validator/validator-frontend && npm install
              sudo npm install serve -g 
              sudo npm run build
              sudo serve -s -l 8081
              #sudo cat ./build >> usr/share/nginx/html
              python3 -m http.server 8080 &
              EOF
}
resource "aws_s3_bucket" "bucket" {
  bucket        = "terraform-one"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_crypto_conf" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "instances" {
  name = "instance-security-group-1"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "instances" {
  name     = "example-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_2.id
  port             = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}


resource "aws_security_group" "alb" {
  name = "alb-security-group-2"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}


resource "aws_lb" "load_balancer" {
  name               = "web-app-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_subnet.ids
  security_groups    = [aws_security_group.alb.id]

}

resource "aws_route53_zone" "primary" {
  name = "devopsdeployed.com"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "devopsdeployed.com"
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage = 20
  # This allows any minor version within the major engine_version
  # defined below, but will also result in allowing AWS to auto
  # upgrade the minor version of your DB. This may be too risky
  # in a real production environment.
  auto_minor_version_upgrade = true
  storage_type               = "standard"
  engine                     = "postgres"
  engine_version             = "12"
  instance_class             = "db.t3.micro"
  name                       = "RDS_DB"
  username                   = "postgres"
  password                   = "AlexandreRuiAurthur"
  skip_final_snapshot        = true
}