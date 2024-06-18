# Terraform AWS Infrastructure

## Overview

This project contains Terraform configurations to provision AWS infrastructure, including a VPC, subnets, security groups, EC2 instances using Launch Templates along with Autoscaling Group (ASG), and a Application Load Bbalancer (ALB).

## Directory Structure

- `main.tf`: Root module configuration.
- `variables.tf`: Variables for the root module.
- `terraform.tfvars`: Variable values for the root module.
- `modules/`: Directory containing Terraform modules.
  - `modules/network`: Module for VPC, Subnets, Internet Gateway (IGW), Route tables and assosiation resources.
  - `modules/security`: Module for security group resources.
  - `modules/compute`: Module for EC2 instance resources, Launch Templates, ASG.
  - `modules/load_balancer`: Module for load balancer resources.


## Instractions

- Go to the AWS Management Console,
- Navigate to DynamoDB,
- Create the table:
    - Table name: terraform-state-lock-table
    - Partition key: LockID (String)
    - Click Create to create the table.


Run the commands below:

# or reinitialize the backend without state migration
terraform init -reconfigure

# Validate the configuration
terraform validate

# Generate an execution plan
terraform plan

# Apply the configuration
terraform apply