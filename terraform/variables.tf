
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "tfstate_bucket" {
  description = "S3 bucket to store terraform state"
  type        = string
}

variable "tfstate_lock_table" {
  description = "DynamoDB table for locking terraform state"
  type        = string
}

variable "app_name" {
  description = "Application name for resources"
  type        = string
  default     = "myapp"
}
