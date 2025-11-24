terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "My-instance" {
        ami = "ami-0ecb62995f68bb549" 
        instance_type = "t3.micro"    
    tags = {
      Name = "MY-EC2-Instance"
    }  
}
