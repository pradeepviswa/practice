

#initialize aws provider
provider "aws"{
    region = "ap-south-1"
    access_key = ""
    secret_key = ""
}

#1. create vpc (virtual private cloud) 10.0.0.0/16
resource "aws_vpc" "lab-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Lab-VPC"
    }
}

#2. create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    Name = "Lab-Gateway"
  }
}



#3. create route table
resource "aws_route_table" "Lab-Route-Table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Lab-Route-Table"
  }
}


#4. create subnet 10.0.1.0/24
resource "aws_subnet" "Lab-Subnet" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Lab-Subnet"
  }
}


#5. associate subnet and route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Lab-Subnet.id
  route_table_id = aws_route_table.Lab-Route-Table.id
}


#6. create security group
resource "aws_security_group" "Lab-Security-Group" {
  name        = "Lab-Security-Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Ping"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Powershell"
    from_port        = 5985
    to_port          = 5985
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Powershell Secure"
    from_port        = 5986
    to_port          = 5986
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "RDP"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Lab Security Group"
  }
}


variable "nics" {}
output "nics_length"{
  value = length(var.nics)

}


#7. create network interface and assign IP 10.0.1.20, 10.0.1.21
resource "aws_network_interface" "lab-nics" {
  count = length(var.nics)
  subnet_id       = aws_subnet.Lab-Subnet.id
  private_ips     = [element(var.nics, count.index)]
  security_groups = [aws_security_group.Lab-Security-Group.id]
  tags = {

      Name = "Lab-Nic-${count.index+1}"
  }
#  attachment {
#    instance     = aws_instance.test.id
#    device_index = 1
#  }
}
#8. create elastic IP 10.0.1.20, 10.0.1.21
resource "aws_eip" "lab-load-balancer" {
  domain = "vpc"
  count = length(var.nics)
  #instance                  = aws_instance.foo.id
  network_interface         = aws_network_interface.lab-nics[count.index].id
  associate_with_private_ip = element(var.nics,count.index)
  depends_on                = [aws_internet_gateway.gw]
  tags = {
    Name = "Lab-EIP-${count.index+1}"
  }
}
output "number-of-nics"{
value = length(aws_network_interface.lab-nics)
}


#9. create instance and assign IPs
resource "aws_instance" "lab-vms"{
   ami = "ami-007020fd9c84e18c7"

   instance_type = "t2.micro"
   count = length(var.nics)
   availability_zone = "ap-south-1a"
   key_name = "education"
  


  network_interface {
    network_interface_id = aws_network_interface.lab-nics[count.index].id
    device_index         = 0
  }
 
  
  #user_data = base64encode(file("${"C:/Study/Terraform/Generic.ps1"}"))
  #user_data = base64encode(file("host.ps1"))

  tags = {

    Name = "Lab-Ansible-${count.index + 1}"
  }
  
  user_data = <<EOF
	#!/bin/bash
		echo "Installing Ansible"
		apt-get update
		apt-get install software-properties-common
		apt-add-repository --yes --update ppa:ansible/ansible
		apt-get install -y ansible
		ansible --version
	EOF  
}


output "server1_IP"{
  #value = "${aws_eip.lab-load-balancer[0].public_ip} | ${aws_eip.lab-load-balancer[0].private_ip}"
  value = "${aws_eip.lab-load-balancer[0].public_ip}"
}
output "server2_IP"{
  value = "${aws_eip.lab-load-balancer[1].public_ip}"
}
output "server2_PrivateIP"{
  value = "${aws_eip.lab-load-balancer[1].private_ip}"
}
