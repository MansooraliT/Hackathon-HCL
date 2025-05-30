terraform {
  backend "s3" {
    bucket         = "patient-appointment-app-tfstate-bucket" 
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock" 
    encrypt        = true
  }
}