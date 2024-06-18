variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the load balancer"
}

variable "target_group_port" {
  description = "The port for the target group"
}

variable "target_group_protocol" {
  description = "The protocol for the target group"
}

variable "health_check_path" {
  description = "The path for the health check"
}

variable "health_check_port" {
  description = "The port for the health check"
}

variable "health_check_protocol" {
  description = "The protocol for the health check"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks before considering the instance healthy"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks before considering the instance unhealthy"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
}

variable "health_check_interval" {
  description = "The amount of time, in seconds, between health checks"
}