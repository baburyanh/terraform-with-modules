variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "The AWS profile to use for authentication"
  default     = "default"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr_block" {
  description = "The CIDR block for public subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr_block" {
  description = "The CIDR block for public subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet1_cidr_block" {
  description = "The CIDR block for private subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr_block" {
  description = "The CIDR block for private subnet 2"
  default     = "10.0.4.0/24"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  default     = "ami-0914547665e6a707c"
}

variable "instance_type" {
  description = "The instance type for the instances"
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  default     = "simple-app"
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
  default     = "EC2-to-ECR"
}

variable "user_data_script_path" {
  description = "The path to the user data script"
  default     = "user_data.sh"
}

variable "volume_size" {
  description = "The size of the volume in GB"
  default     = 8
}

variable "volume_type" {
  description = "The type of volume"
  default     = "gp2"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instances"
  default     = true
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  default     = 3
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  default     = 2
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the load balancer"
  default     = false
}

variable "health_check_path" {
  description = "The path for the health check"
  default     = "/login"
}

variable "health_check_port" {
  description = "The port for the health check"
  default     = 3000
}

variable "health_check_protocol" {
  description = "The protocol for the health check"
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks before considering the instance healthy"
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks before considering the instance unhealthy"
  default     = 2
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
  default     = 3
}

variable "health_check_interval" {
  description = "The amount of time, in seconds, between health checks"
  default     = 30
}