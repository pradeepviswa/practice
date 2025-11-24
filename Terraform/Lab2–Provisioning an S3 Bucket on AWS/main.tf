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

resource aws_s3_bucket "my_bucket"{

    bucket = "pv-bucket-name-1039"
    tags = {
        Name = "My S3 Bucket"
        Environment = "Dev"
    }

}