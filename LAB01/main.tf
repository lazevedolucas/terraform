provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/lazevedo/.aws/credentials"
  profile                 = "lucas-pessoal"
}

resource "aws_vpc" "teste_tf" {
  cidr_block = "10.100.0.0/16"
  tags {
    name = "teste_tf"
  }
}

resource "aws_subnet" "teste_tf" {
  vpc_id = "${aws_vpc.teste_tf.id}"
  cidr_block = "10.100.0.0/24"
  availability_zone = "us-east-1a"
  tags {
    name = "teste_tf"
  }
}

resource "aws_instance" "teste_tf" {
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.ssh_only.id}"]
  subnet_id = "${aws_subnet.teste_tf.id}"
  associate_public_ip_address = "true"

}
resource "aws_security_group" "ssh_only" {
  name  = "ssh_only"
  description = "Allow SSH Only to All"
  vpc_id = "${aws_vpc.teste_tf.id}"

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
    name= "ssh_only"
  }
}
