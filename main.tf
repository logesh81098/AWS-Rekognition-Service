module "s3" {
  source = "./module/S3"
  face-prints-function-arn = module.lambda-function.face-prints-function-arn
}

module "iam-role" {
  source = "./module/IAM-Role"
}

module "lambda-function" {
  source = "./module/Lambda-Function"
  rekognition-collection-id-role = module.iam-role.rekognition-collection-id-role
  face-prints-role = module.iam-role.face-prints-role
  s3-bucket-arn = module.s3.source-bucket-arn
}

module "dynamodb-table" {
  source = "./module/DynamoDB-Table"
}