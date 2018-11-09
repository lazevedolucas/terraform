provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/lazevedo/.aws/credentials"
  profile                 = "default"
}

resource "aws_vpc" "vpc_modelo" {
  cidr_block = "10.200.0.0/16"
  enable_dns_hostnames = true
  tags {
    name = "vpc_modelo"
    Owner = "lucas.azevedo"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.vpc_modelo.id}"
  tags  {
    name = "vpc_modelo"
    Owner = "lucas.azevedo"
  }
}

resource "aws_route_table" "subnet_pub1" {
  vpc_id  = "${aws_vpc.vpc_modelo.id}"
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id  = "${aws_internet_gateway.default.id}"
    }
    tags {
      name = "vpc_modelo"
      Owner = "lucas.azevedo"
  }
}

resource "aws_subnet" "subnet_pub1" {
  vpc_id = "${aws_vpc.vpc_modelo.id}"
  cidr_block = "10.200.1.0/24"
  availability_zone = "us-east-1a"
  tags {
    name = "subnet_pub1"
    Owner = "lucas.azevedo"
  }
}

resource "aws_route_table_association" "subnet_pub1" {
  subnet_id = "${aws_subnet.subnet_pub1.id}"
  route_table_id = "${aws_route_table.subnet_pub1.id}"
  tags {
    name = "rtsubnet_pub1"
    Owner = "lucas.azevedo"
  }
}

resource "aws_subnet" "subnet_priv1" {
  vpc_id = "${aws_vpc.vpc_modelo.id}"
  cidr_block = "10.200.2.0/24"
  availability_zone = "us-east-1a"
  tags {
    name = "subnet_priv1"
    Owner = "lucas.azevedo"
  }
}

resource "aws_instance" "ec2_subnet_pub1" {
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.ssh_only.id}"]
  subnet_id = "${aws_subnet.subnet_pub1.id}"
  associate_public_ip_address = "true"
  tags {
    name = "ec2_subnet_pub1"
    Owner = "lucas.azevedo"
  }
}

resource "aws_instance" "ec2_subnet_priv1" {
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.ssh_only.id}"]
  subnet_id = "${aws_subnet.subnet_priv1.id}"
  associate_public_ip_address = "false"
  tags {
    name = "ec2_subnet_priv1"
    Owner = "lucas.azevedo"
  }
}

resource "aws_security_group" "ssh_only" {
  name  = "ssh_only"
  description = "Allow SSH Only to All"
  vpc_id = "${aws_vpc.vpc_modelo.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    name = "ssh_only"
    Owner = "lucas.azevedo"
  }
}
