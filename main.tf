data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "terra-key"
  #   security_groups = [aws_security_group.terraform_ec2_security.name]
  tags = {
    Name = "terraform-compute"
  }
}

# working code part but add new security group and allowing 22 port 
# resource "aws_default_vpc" "main" {
#   tags = { Name = "main" }
# }


# resource "aws_security_group" "terraform_ec2_security" {
#   name        = "terraform"
#   description = "terraform security group"
#   vpc_id      = aws_default_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "default" {
  name        = "default"
  description = "Default Security Group"
}

resource "aws_security_group_rule" "ingress_rule" {
  security_group_id = aws_security_group.default.id

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # Allow traffic from any source. You may want to restrict this based on your requirements.
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "egress_rule" {
  security_group_id = aws_security_group.default.id

  type = "egress"
  # Allow all egress traffic
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
