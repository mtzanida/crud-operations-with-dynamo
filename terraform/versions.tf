terraform {
  required_version = "~> 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }

  }
}
