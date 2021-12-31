resource "aws_key_pair" "vas" {
  key_name   = "vas"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSfOSZEjQQD8BDTj3G4w8cR6GE1hnEvUugcUYvbdIGqE6EQ97wuZ/qGhb8GePYqR5C4rU7aEYs2NDPT6KAtQdSPF54X8So5HcVSD+mxbtrC2KwiZOmaYtf2AQwV3V2WrIDdJdO5wR7mL6QbzmwXZyjII9tz9eRgglK9CO2pT9SW4UHWwqjVn1jfOZVP2uk//RZKxMmOJuoyuhbVlvlcUQAMuEwDcSoJYKpeoB++9nONi8Iia38UiGbZh1Hr1nJUcZV6sSlvfgYgU266vAi1i/q2LhLGwH8P2kWAKoxOyYnpRIG8ukdbzKL1sv6kneoLy6x2b13o8u7eM+iZPU+CRhR sree"
}


resource "aws_instance" "public1" {
  ami                         = "ami-002068ed284fb165b"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.vas.id
  vpc_security_group_ids      = [aws_security_group.public1.id]
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.public_1.id
  user_data                   = <<-EOF
                                #!/bin/bash
                                sudo yum update -y
                                sudo amazon-linux-extras install docker -y
                                sudo service docker start
                                sudo usermod -a -G docker ec2-user
                                sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
                                sudo chmod +x /usr/local/bin/docker-compose
                                sudo docker pull nginx:latest
                                sudo docker run -p 80:80 nginx:latest
                                EOF

  tags = {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "tf-alb-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
}

resource "aws_lb" "my_alb" {
  name                       = "alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups            = [aws_security_group.public1.id]
  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
