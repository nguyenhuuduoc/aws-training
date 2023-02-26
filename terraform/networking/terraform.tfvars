# ------------------------------------------------------------------------------
# Common variables
# ------------------------------------------------------------------------------
region           = "us-east-1"
vpc_name         = "duocnh-dev-vpc"
cidr             = "10.10.0.0/16"
azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets   = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnets  = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
database_subnets = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

tags = {
  Terraform   = "true"
  Environment = "dev"
}

# ------------------------------------------------------------------------------
# VPC Endpoints
# ------------------------------------------------------------------------------
vpce_sg_name              = "vpce-sg"
s3_endpoint_name          = "s3-endpoint"
ssm_endpoint_name         = "ssm-endpoint"
ec2messages_endpoint_name = "ec2messages-endpoint"
ssmmessages_endpoint_name = "ssmmessages-endpoint"
