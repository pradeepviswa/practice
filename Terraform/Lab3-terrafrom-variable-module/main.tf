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



module "vm_instance" {
    # source = "./modules/vm"
    source = "git::https://github.com/pradeepviswa/tfmodules.git//vm"
    ami_id = var.ami_id
    instance_type = var.instance_type
    vm_name = var.vm_name
    env = var.env
}