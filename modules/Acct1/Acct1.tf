terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

###############################################################################
### EC2 Security Group
###############################################################################
resource "aws_security_group" "ec2" {
  name        = "TF-ec2-sg"
  description = "Allow traffic local VPC"
  vpc_id      = local.vpc-id

  ingress {
    description      = ""
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

  ingress {
    description      = "Allow SSH traffic from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

  egress {
    description      = "Outbound allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
###############################################################################

###############################################################################
### Create EC2 Instance for Access the S3 Access Point
###############################################################################
resource "aws_instance" "ec2-test" {
  ami           = local.ec2-ami
  instance_type = local.ec2-instance-type
  subnet_id     = local.ec2-subnet-id
  key_name      = local.ec2-key-name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = local.ec2-instance-name
  }
}
###############################################################################


###############################################################################
### Create TGW and corresponding attachments.
###############################################################################
resource "aws_ec2_transit_gateway" "s3ap" {
  description = "TGW for S3 Access Point Terraform Demo"

  tags = {
    Name = format("%s%s",local.tf-job-name,"-tgw")
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "s3ap" {
  subnet_ids         = [local.ec2-subnet-id]
  transit_gateway_id = aws_ec2_transit_gateway.s3ap.id
  vpc_id             = local.vpc-id
}
###############################################################################

locals {
    tf-job-name       = "tf-s3-ap"
    ec2-ami           = "ami-0c02fb55956c7d316"
    ec2-instance-type = "t3.micro"
    ec2-instance-name = "djl-test-ap-ec2"
    ec2-subnet-id     =  "subnet-069a69e50bd1ebb23"
    ec2-key-name      = "DemoVPC_Key_Pair"
    vpc-id            = "vpc-00b09e53c6e62a994"
}