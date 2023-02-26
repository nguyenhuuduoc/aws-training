# ------------------------------------------------------------------------------
# VPC Endpoints
# ------------------------------------------------------------------------------
resource "aws_security_group" "vpce" {
  name        = var.vpce_sg_name
  description = "[terraform-managed] Allow VPC endpoint access"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.vpce_sg_name
  }
}

resource "aws_security_group_rule" "all_vpc" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = [var.cidr]
  security_group_id = aws_security_group.vpce.id

  depends_on = [
    aws_security_group.vpce,
  ]
}

resource "aws_security_group_rule" "all" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpce.id

  depends_on = [
    aws_security_group.vpce,
  ]
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = flatten(["${var.public_route_table_ids}",
                               "${var.private_route_table_ids}",
                               "${var.database_route_table_ids}"])

  tags = {
    Name = join(" ", [var.vpc_name, var.s3_endpoint_name])
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpce.id,
  ]
  subnet_ids = var.private_subnets

  tags = {
    Name = var.ssm_endpoint_name
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpce.id,
  ]
  subnet_ids = var.private_subnets

  tags = {
    Name = join(" ", [var.vpc_name, var.ec2messages_endpoint_name])
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpce.id,
  ]
  subnet_ids = var.private_subnets

  tags = {
    Name = join(" ", [var.vpc_name, var.ssmmessages_endpoint_name])
  }
}
