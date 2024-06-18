variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "public_subnet1_cidr_block" {
  description = "The CIDR block for public subnet 1"
}

variable "public_subnet2_cidr_block" {
  description = "The CIDR block for public subnet 2"
}

variable "private_subnet1_cidr_block" {
  description = "The CIDR block for private subnet 1"
}

variable "private_subnet2_cidr_block" {
  description = "The CIDR block for private subnet 2"
}

variable "availability_zone1" {
  description = "Availability zone 1"
}

variable "availability_zone2" {
  description = "Availability zone 2"
}