terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}

variable "tfstate_bucket" {
  description = "Name of S3 bucket for Terraform state"
  type        = string
}

variable "tfstate_lock_table" {
  description = "Name of DynamoDB table for state locking"
  type        = string
}

# Create S3 bucket
resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucket
  acl    = "private"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = var.tfstate_lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
