terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module vm_loop{
  # source = "./modules/vm_loop"
  source = "git::https://github.com/pradeepviswa/tfmodules.git//vm_loop"
  instances = var.instances

}