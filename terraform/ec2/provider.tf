# Specify the required version of the AWS provider for this Terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.33.0"
    }
  }
}

# Configure the AWS provider to use the "duocnh-dev" AWS profile and the region specified in the "var.region" variable
provider "aws" {
  # Use the "duocnh-dev" AWS profile for authentication
  profile = "duocnh-dev"

  # Set the AWS region where resources will be created
  region  = var.region
}
