data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  //Give below variable a list of security groups you want to apply to this instance
  // vpc_security_group_ids = [aws_security_group.blog.id]
  vpc_security_group_ids = [module.blog_sg.security_group_id]


  tags = {
    Name = "Bitnami"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  name    = "blog_sg"
  vpc_id             = data.aws_vpc.default.id
  ingress_rules      = ["https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  eggress_rules      = ["all-all"]
  eggress_cidr_blocks = ["0.0.0.0/0"]
}



/*
//Defining security group

resource "aws_security_group" "blog" {
  name        = "bitnami_sg"
  description = "Allow http/https inbound"

  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  
  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  
  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  
  security_group_id = aws_security_group.blog.id
}
*/