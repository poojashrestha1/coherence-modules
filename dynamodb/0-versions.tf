terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
