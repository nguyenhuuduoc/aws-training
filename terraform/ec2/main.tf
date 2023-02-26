# aws_security_group.app:
resource "aws_security_group" "app" {
    description = "dev-app-sg"
    name        = "dev-app-sg"
    vpc_id      = "vpc-008ded3599235862c"

    tags        = var.tags
}

# aws_security_group_rule.app:
resource "aws_security_group_rule" "app" {
    security_group_id = aws_security_group.app.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0",
    ]
}


resource "aws_iam_role" "ec2" {
    name        = "TerraformRole"
    description = "IAM role used by EC2 in the tooling account"

    assume_role_policy = jsonencode(
        {
            "Version": "2008-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    )

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
}

resource "aws_iam_instance_profile" "app" {
    name_prefix = "profile-"
    role        = aws_iam_role.ec2.name
}

# aws_instance.app:
resource "aws_instance" "app" {
    ami                                  = "ami-0dfcb1ef8550277af"
    availability_zone                    = "us-east-1a"
    subnet_id                            = "subnet-0d371e8f3022f9eaf"
    instance_type                        = "t2.micro"
    monitoring                           = false
    associate_public_ip_address          = true
    iam_instance_profile                 = aws_iam_instance_profile.app.name
    vpc_security_group_ids               = [
        aws_security_group.app.id,
    ]

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 10
        volume_type           = "gp2"
    }

    # User data script to install Docker and Docker Compose
    user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y yum-utils device-mapper-persistent-data lvm2
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF

    tags = merge({"Name" = "dev-app"}, var.tags)
}
