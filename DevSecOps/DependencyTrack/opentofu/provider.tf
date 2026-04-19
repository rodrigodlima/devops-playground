terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
    shared_config_files      = ["/Users/rodrigo/.aws/config"]
    shared_credentials_files = ["/Users/rodrigo/.aws/credentials"]
    profile                  = "default"
}