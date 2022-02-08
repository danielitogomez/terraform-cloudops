#ssh key, this should be a secret
resource "aws_key_pair" "tf-ec2-instance-aws" {
  key_name   = "tf-ec2-instance-aws"
  public_key = file(var.ssh_key)
}

data "template_file" "init" {
  template = file(var.init_install)
}

# Instance EC2
resource "aws_instance" "ec2-instance-instanc" {
  ami                    = "ami-06b263d6ceff0b3dd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tf-ec2-instance-aws.key_name
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_ec2-instance.id]
  subnet_id              = aws_subnet.private_subnet_a.id
  user_data = file(var.init_install)
  tags = {
    Name = "terraform-EC2 Instance"
  }
}

# Security Groups
resource "aws_security_group" "sg_allow_ssh_ec2-instance" {
  name        = "allow_ssh_ec2-instance"
  description = "Allow SSH and ec2-instance inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
