# Define the AWS provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "terraform-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = "eu-north-1a"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = "eu-north-1b"
}

# Create private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = "eu-north-1a"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = "eu-north-1b"
}

# Create internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

# Attach internet gateway to public subnets
resource "aws_route_table" "public_route_table1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table1.id
}

resource "aws_route_table" "public_route_table2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "terraform-route-table"
  }
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table2.id
}

# Create security groups
resource "aws_security_group" "allow_ssh_http_tcp" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create a network interface
resource "aws_network_interface" "example" {
  subnet_id   = aws_subnet.private_subnet1.id
  private_ips = ["10.0.3.100"] # Specify private IP addresses as needed
}


# Create launch template
data "template_file" "user_data" {
  template = file(var.user_data_script_path)
}

resource "aws_launch_template" "my_template" {
  name          = "my-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.iam_instance_profile_name # IAM role name
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
  }

  key_name                             = var.key_name
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = true

  network_interfaces {
    security_groups             = [aws_security_group.allow_ssh_http_tcp.id]
    associate_public_ip_address = var.associate_public_ip_address # Assign public IP addresses
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.volume_size # Size of the volume in GB
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }

}

# Create autoscaling group
resource "aws_autoscaling_group" "my_asg" {
  name = "my-asg"
  launch_template {
    id      = aws_launch_template.my_template.id
    version = aws_launch_template.my_template.latest_version
  }
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  tag {
    key                 = "Name"
    value               = "terraform-instance"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.my_target_group.arn]

}


# Create application load balancer
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http_tcp.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  enable_deletion_protection = var.enable_deletion_protection
}

# Create target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 3000
  protocol = var.health_check_protocol
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
  }
}

# Create ALB listener
resource "aws_lb_listener" "lb_front_end" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}