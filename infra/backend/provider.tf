# Setup our aws provider
variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "testing"
}

provider "aws" {
  region  = var.region
  profile = var.profile
  # Access and secrets keys, this should be a secret or you can export this var
  # variable "access_key" {
  #   default = ""
  # }
  # variable "secret_key" {
  #   default = ""
  # }
  # export access_key=the_value
  # export secret_key=the_value
  access_key = ""
  secret_key = ""
}

terraform {
  backend "s3" {
    bucket         = "hello1234a-terraform-infra"
    region         = "eu-west-1"
    dynamodb_table = "hello1234a-terraform-locks"
    key            = "backend/terraform.tfstate"
  }
}