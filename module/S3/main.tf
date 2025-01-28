################################################################################################################################################
#                                                    Deploying S3 bucket 
################################################################################################################################################

#Source S3 bucket 

resource "aws_s3_bucket" "source-bucket" {
  bucket = "peoples-source-image"
  tags = {
    Name = "peoples-source-image"
    Project = "Face Recognition"
  }
}

################################################################################################################################################
#                                                  Trigger Lambda Function
################################################################################################################################################

resource "aws_s3_bucket_notification" "trigger-lambda-function" {
  bucket = aws_s3_bucket.source-bucket.id
  lambda_function {
    lambda_function_arn = var.face-prints-function-arn
    events = ["s3:ObjectCreated:*"]
  }
}