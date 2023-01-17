main.tf
provider "aws" {
  profile = "terraform-session"
  region = "eu-north-1"
}

resource "aws_s3_bucket" "rugged_buckets" {
  count         = length(var.s3_bucket_names) 
  bucket        = var.s3_bucket_names[count.index]
  force_destroy = true
}
================================================
var.tf
variable "s3_bucket_names" {
  type = list
  default = ["zupta.app", 
             "zupta1.app", 
             "zupta2.app",
             "zupta3.app",
             "zupta4.app",
             "zupta5.app",
             "zupta6.app",
             "zupta7.app",
             "zupta8.app",
             "zupta9.app"
            ]
}
==============================================
this will create 10 buckets in aws s3
============================================
code to create 5 ec2 instance in aws ec2 using terraform
main.tf
provider "aws" {
  profile = "terraform-session"
  region = "eu-north-1"
}

resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type

  tags = {
    Name  = "Terraform-${count.index + 1}"
    Batch = "PK"
  }
}
=================================================
var.tf
variable "ami" {
  type = map

  default = {
    "eu-north-1" = "ami-0fd303abd14827300"
    "eu-north-1" = "ami-06410fb0e71718398"
  }
}

variable "instance_count" {
  default = "5"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "aws_region" {
  default = "eu-north-1"
}
====================================================
this will create 5 ec2 machines
==============================================
code to create 10 users in terraform
main.tf
provider "aws" {
  profile = "terraform-session"
  region = "eu-north-1"
}

resource "aws_iam_user" "users" {
  count = length(var.iamusers)
  name = var.iamusers[count.index]
  
}
===========================================
var.tf
variable "iamusers" {
    type = list(string)
    default = [ "rica","pawan","vaibhav","mayur","anjali","rahul","ram","ravi","chaman","yudhistir" ]
  
}
=========================================
this will create 10 users
===============================
ASK = 1 (create 4 user add them to group with name devops)
===========================================================================================================
main.tf

provider "aws" {
  profile = "uu"
  region = "us-east-1"
}
resource "aws_iam_user" "rs1" {
 name = var.userone
}
resource "aws_iam_user" "rs2" {
  name = var.u2
  
}
resource "aws_iam_user" "rs3" {
 name = var.u3
  
}
resource "aws_iam_user" "rs4" {
  name = var.u4
}
resource "aws_iam_group" "rs5" {
  name = var.u5
  
}
resource "aws_iam_group_membership" "grup_mem" {
  name = "group ahe ha"
  users = [aws_iam_user.rs1.name,aws_iam_user.rs2.name,aws_iam_user.rs3.name,aws_iam_user.rs4.name]
  group = aws_iam_group.rs5.name
  
}
============================================================================
var.tf

variable "userone" {
  type= string
  default = "userone"
}
variable "u2" {
  type=string
  default = "usertwo"
}
variable "u3" {
  type=string
  default = "userthree"
}
variable "u4" {
  type=string
  default = "userfour"
}
variable "u5" {
  type = string
  default = "devops"
  
}
===============================================================================
TASK = 2 (create ec2 instance and add 2 security group for same instance)

main.tf

provider "aws" {
  profile = "uu"
  region = "us-east-1"
}

resource "aws_instance" "my-instance" {
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type

  tags = {
    Name  = "Terraform"
    Batch = "PK"
  }
}
resource "aws_security_group" "sec_group" {
  name   = "sec_group"
  vpc_id = "vpc-0c9b17c90202b1fb4"
}
resource "aws_security_group" "http" {
  name        = "sg"
  description = "Web Security Group for HTTP"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_security_group" "ssh" {
  name        = "sg1"
  description = "Web Security Group for ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.http.id
  network_interface_id = aws_instance.my-instance.primary_network_interface_id
}

==================================================================================

var.tf

variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-06878d265978313ca"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

=======================================================================================
TASK 3 = (create vpc with 2 subnet)

main.tf

provider "aws" {
  profile = "uu"
  region = "us-east-1"

}
# Crate a AWS VPC which contains the following
#   - VPC
#   - Public subnet(s)
#   - Private subnet(s)
#   - Internet Gateway
#   - Routing table
data "aws_region" "current" {}                     
data "aws_availability_zones" "available" {}
resource "aws_vpc" "testapp" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # Internal domain name
  enable_dns_hostnames = true # Internal host name

  tags = {
    Name = "testapp-vpc"
  }
}

resource "aws_subnet" "testapp_public_subnet" {
  # Number of public subnet is defined in vars
  count = var.number_of_public_subnets

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index + 2}.0/24"
  vpc_id                  = aws_vpc.testapp.id
  map_public_ip_on_launch = true # This makes the subnet public

  tags = {
    Name = "testapp-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "testapp_private_subnet" {
  # Number of private subnet is defined in vars
  count = var.number_of_private_subnets

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.testapp.id

  tags = {
    Name = "testapp-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "testapp_internet_gateway" {
  vpc_id = aws_vpc.testapp.id

  tags = {
    Name = "testapp-internet-gateway"
  }
}

resource "aws_route_table" "testapp_route_table" {
  vpc_id = aws_vpc.testapp.id

  route {
    # Associated subet can reach public internet
    cidr_block = "0.0.0.0/0"

    # Which internet gateway to use
    gateway_id = aws_internet_gateway.testapp_internet_gateway.id
  }

  tags = {
    Name = "testapp-public-custom-rtb"
  }
}

resource "aws_route_table_association" "testapp-custom-rtb-public-subnet" {
  count          = 2
  route_table_id = aws_route_table.testapp_route_table.id
  subnet_id      = aws_subnet.testapp_public_subnet.*.id[count.index]
}
===========================================================================================

var.tf

variable "number_of_public_subnets" {
  default = 2
}

variable "number_of_private_subnets" {
  default = 2
}

==========================================================================================

TASK 4 = (create s3 bucket with random policy)

main.tf

provider "aws" {
  profile = "uu"
  region = "us-east-1"

}
resource "aws_s3_bucket" "demo-bucket"{
  bucket = "zhinga"
}

  resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.demo-bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.demo-bucket.arn}",
        "${aws_s3_bucket.demo-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}
================================================================================================
 
 TASK 5 = (create ec2 instance and attach iam role with admin access policy to the same instance)

main.tf

provider "aws" {
  profile = "uu"
  region = "us-east-1"

}
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_instance" "role-test" {
  ami = "ami-06878d265978313ca"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
}
===================================================================================

iam.tf

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}
=================================================================
Dyanmic block example
main.tf
provider "aws" {
  profile = "terraform-session"
  region = "eu-north-1"
}
resource "aws_instance" "my-instance" {
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type

  tags = {
    Name  = "Terraform"
    Batch = "PK"
  }
}
resource "aws_security_group" "sec_group" {
  name   = "sec_group"
  vpc_id = "vpc-025ba5b93ebe769da"
  description = "Web Security Group for HTTP"
  dynamic "ingress" {
    for_each = [ 80,443,22,8080 ]
    iterator = port
    content {
      description = "Web Security Group for HTTP"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 
  }
}



===========
variable "ami" {
  type = map

  default = {
    "eu-north-1" = "ami-03df6dea56f8aa618"
  }
}

variable "instance_type" {
  default = "t3.micro"
}

variable "aws_region" {
  default = "eu-north-1"
}
======================================
user data script
	main.tf
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id = var.subnet_id
  user_data = <<EOF
  #!/bin/bash
sudo apt update -y
sudo apt install default-jre -y
sudo apt install nfs-common -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
mkdir -p /var/lib/jenkins
sudo apt install jenkins -y
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo systemctl start jenkins
  EOF

  tags = {
    Name = "jenkins-instance"
  }
}
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "for jenkins"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "tls_private_key" "jen" {
  algorithm = "RSA"
  rsa_bits = "4096"
  
}

# resource "aws_key_pair" "jenkins-key" {
#   key_name = "jenkins-key"
#   public_key = tls_private_key.jen
  
# }
var.tf
variable "instance_type" {
  type = string
  
}
variable "key_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
	

