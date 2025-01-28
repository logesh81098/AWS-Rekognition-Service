module "s3" {
  source = "./module/S3"
}

module "iam-role" {
  source = "./module/IAM-Role"
}