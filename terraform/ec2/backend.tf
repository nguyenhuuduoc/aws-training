# ---------------------------------------------------------------------------------------------------------------------
# Set up the Terraform backend to use S3 storage for the "terraform.tfstate" file
# Enable versioning on the S3 bucket to keep track of changes to the state file over time
# ---------------------------------------------------------------------------------------------------------------------

# Configure the Terraform backend to use S3 storage
terraform {
  backend "s3" {
    # Use the "duocnh-dev" AWS profile for authentication
    profile = "duocnh-dev"

    # Specify the S3 bucket to store the state file
    bucket  = "duocnh-terraform-state"

    # Set the path to the state file within the bucket
    key     = "terraform/dev/ec2/terraform.tfstate"

    # Set the AWS region where the S3 bucket is located
    region  = "us-east-1"

    # Enable encryption of the state file at rest in S3
    encrypt = true
  }
}
