# aws_security_group.app:
resource "aws_security_group" "app" {
    description = "dev-bastion-host-sg"
    name        = "dev-bastion-host-sg"
    vpc_id      = "vpc-008ded3599235862c"

    tags        = {}
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


# aws_instance.app:
resource "aws_instance" "app" {
    ami                                  = "ami-0dfcb1ef8550277af"
    availability_zone                    = "us-east-1a"
    subnet_id                            = "subnet-02cb15e29cfe58d1d"
    instance_type                        = "t2.micro"
    monitoring                           = false
    associate_public_ip_address          = false

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
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install docker -y
#               sudo service docker start
#               sudo usermod -a -G docker ec2-user
#               sudo yum install -y python3-pip
#               sudo pip3 install docker-compose
#               EOF

    tags = {
        "Name" = "dev-bastion-host"
    }
}
