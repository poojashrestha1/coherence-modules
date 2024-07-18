terraform {
  required_version = ">= 1.7.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
  }
}
