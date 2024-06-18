variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
}

variable "instance_type" {
  description = "The instance type for the instances"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
}

variable "user_data_script_path" {
  description = "The path to the user data script"
}

variable "volume_size" {
  description = "The size of the volume in GB"
}

variable "volume_type" {
  description = "The type of volume"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instances"
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "target_group_arns" {
  description = "The ARNs of the target groups"
  type        = list(string)
}