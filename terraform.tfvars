aws_region  = "eu-north-1"
aws_profile = "default"

vpc_cidr_block             = "10.0.0.0/16"
public_subnet1_cidr_block  = "10.0.1.0/24"
public_subnet2_cidr_block  = "10.0.2.0/24"
private_subnet1_cidr_block = "10.0.3.0/24"
private_subnet2_cidr_block = "10.0.4.0/24"

ami_id                    = "ami-0914547665e6a707c"
instance_type             = "t3.micro"
key_name                  = "simple-app"
iam_instance_profile_name = "EC2-to-ECR"

user_data_script_path = "user_data.sh"

volume_size                 = 8
volume_type                 = "gp2"
associate_public_ip_address = true

min_size         = 1
max_size         = 3
desired_capacity = 2

enable_deletion_protection = false

health_check_path                = "/login"
health_check_port                = 3000
health_check_protocol            = "HTTP"
health_check_healthy_threshold   = 2
health_check_unhealthy_threshold = 2
health_check_timeout             = 3
health_check_interval            = 30