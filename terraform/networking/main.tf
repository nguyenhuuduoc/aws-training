# ------------------------------------------------------------------------------
# Elastic IP
# ------------------------------------------------------------------------------

# Define an Elastic IP resource
# aws_eip.nat will be created once with a count of 1
# This resource will be used later for the NAT gateway
# resource "aws_eip" "nat" {
#   count = 1
#   vpc   = true

#   # Add a tag to the Elastic IP resource
#   tags = {
#     "Name" = "NAT Gateway"
#   }
# }

# ------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------

# Define a VPC module from the terraform-aws-modules/vpc/aws module
# This module will create a new VPC with the specified configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # Pass in variables to the VPC module
  name             = var.vpc_name
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # Enable a single NAT Gateway for all public subnets
  # Note: These settings are commented out to disable NAT Gateway creation
  # enable_nat_gateway     = true
  # single_nat_gateway     = true
  # one_nat_gateway_per_az = false
  # reuse_nat_ips          = true
  # external_nat_ip_ids    = aws_eip.nat.*.id

  # Enable DNS support and hostnames for the VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Disable VPC flow logs
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false

  # Add tags to the VPC resources for easy identification
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


# ------------------------------------------------------------------------------
# VPC endpoints
# ------------------------------------------------------------------------------
module "vpc-endpoints" {
  source = "./modules/vpc-endpoints"

  region = var.region
  cidr   = var.cidr

  vpc_name                 = module.vpc.name
  vpc_id                   = module.vpc.vpc_id
  public_route_table_ids   = module.vpc.public_route_table_ids
  private_route_table_ids  = module.vpc.private_route_table_ids
  database_route_table_ids = module.vpc.database_route_table_ids
  private_subnets          = module.vpc.private_subnets

  vpce_sg_name              = var.vpce_sg_name
  s3_endpoint_name          = var.s3_endpoint_name
  ssm_endpoint_name         = var.ssm_endpoint_name
  ec2messages_endpoint_name = var.ec2messages_endpoint_name
  ssmmessages_endpoint_name = var.ssmmessages_endpoint_name

  depends_on = [
    module.vpc
  ]
}

