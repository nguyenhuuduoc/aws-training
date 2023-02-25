# ---------------------------------------------------------
# Elastic IP
# ---------------------------------------------------------
# resource "aws_eip" "nat" {
#   count = 1
#   vpc   = true

#   tags = {
#     "Name" = "NAT Gateway"
#   }
# }


# ---------------------------------------------------------
# VPC
# ---------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = var.name
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

# A single NAT Gateway
  # enable_nat_gateway     = true
  # single_nat_gateway     = true
  # one_nat_gateway_per_az = false
  # reuse_nat_ips          = true
  # external_nat_ip_ids    = aws_eip.nat.*.id

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
