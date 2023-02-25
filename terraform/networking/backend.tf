# ---------------------------------------------------------------------------------------------------------------------
# S3 backend where stores the file "terraform.tfstate". Bucket Versioning should be enables
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  backend "s3" {
    profile = "duocnh-dev"
    bucket  = "duocnh-terraform-state"
    key     = "terraform/dev/networking/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
