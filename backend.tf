terraform {
  backend "s3" {
    bucket = "terraform-backend-files-logesh"
    key = "AWS-Rekognition-Service.tfstate"
    region = "us-east-1"
  }
}