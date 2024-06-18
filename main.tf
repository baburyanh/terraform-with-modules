provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "week5-tfstate-bucket"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
  }
}


# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Apply private ACL (Optional, since it's the default setting)
# resource "aws_s3_bucket_acl" "terraform_state_acl" {
#  bucket = aws_s3_bucket.terraform_state.bucket
#  acl    = "private"
#}


resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


module "network" {
  source = "./modules/network"

  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet1_cidr_block  = var.public_subnet1_cidr_block
  public_subnet2_cidr_block  = var.public_subnet2_cidr_block
  private_subnet1_cidr_block = var.private_subnet1_cidr_block
  private_subnet2_cidr_block = var.private_subnet2_cidr_block
  availability_zone1         = "eu-north-1a"
  availability_zone2         = "eu-north-1b"
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  iam_instance_profile_name = var.iam_instance_profile_name
  user_data_script_path     = var.user_data_script_path
  volume_size               = var.volume_size
  volume_type               = var.volume_type
  associate_public_ip_address = var.associate_public_ip_address
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  public_subnet_ids         = [module.network.public_subnet1_id, module.network.public_subnet2_id]
  security_group_id         = module.security.security_group_id
  target_group_arns         = [module.load_balancer.target_group_arn]
}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id                     = module.network.vpc_id
  security_group_id          = module.security.security_group_id
  public_subnet_ids          = [module.network.public_subnet1_id, module.network.public_subnet2_id]
  enable_deletion_protection = var.enable_deletion_protection
  target_group_port          = var.health_check_port
  target_group_protocol      = var.health_check_protocol
  health_check_path          = var.health_check_path
  health_check_port          = var.health_check_port
  health_check_protocol      = var.health_check_protocol
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout             = var.health_check_timeout
  health_check_interval            = var.health_check_interval
}