 terraform {
  backend "s3" {
    bucket         = "week5-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"  # To enable state locking with DynamoDB
    }
}