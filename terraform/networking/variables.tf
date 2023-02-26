# ------------------------------------------------------------------------------
# Common variables
# ------------------------------------------------------------------------------
variable "region" {}
variable "vpc_name" {}
variable "cidr" {}
variable "azs" {}
variable "tags" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "database_subnets" {}

# ------------------------------------------------------------------------------
# VPC endpoints
# ------------------------------------------------------------------------------
variable "vpce_sg_name" {}
variable "s3_endpoint_name" {}
variable "ssm_endpoint_name" {}
variable "ec2messages_endpoint_name" {}
variable "ssmmessages_endpoint_name" {}
