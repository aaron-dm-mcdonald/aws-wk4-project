terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use latest version if possible
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "default"
}
