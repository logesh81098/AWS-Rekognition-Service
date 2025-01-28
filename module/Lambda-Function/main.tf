##################################################################################################################################################
#                                                   Archive the source code
##################################################################################################################################################

#Archive the python file into Zip file so that Lambda function can work on it 
data "archive_file" "rekognition-collection-id-zip" {
  type = "zip"
  source_dir = "module/Lambda-Function"
  output_path = "module/Lambda-Function/rekognition-collection-id.zip"
}

##################################################################################################################################################
#                                                 Deploying Lambda Function
##################################################################################################################################################

#Lambda function to create collection ID in Rekogntion 

resource "aws_lambda_function" "rekognition-collection-id" {
  function_name = "rekognition-collection-id"
  runtime = "python3.8"
  timeout = "20"
  handler = "face-rekognition-collection-id.lambda_handler"
  role = var.rekognition-collection-id-role
  filename = "module/Lambda-Function/rekognition-collection-id.zip"
  tags = {
    Name = "rekognition-collection-id"
    Project = "Face-Rekognition"
  }
}


##################################################################################################################################################
#                                                   Archive the source code
##################################################################################################################################################

#Archive the python file into Zip file so that Lambda function can work on it 

data "archive_file" "face-prints" {
  type = "zip"
  source_dir = "module/Lambda-Function"
  output_path = "module/Lambda-Function/faceprints.zip"
}

##################################################################################################################################################
#                                                 Deploying Lambda Function
##################################################################################################################################################

#Lambda function to create and store Faceprints

resource "aws_lambda_function" "face-prints" {
  function_name = "face-prints"
  runtime = "python3.8"
  timeout = "20"
  role = var.face-prints-role
  handler = "faceprints.lambda_handler"
  filename = "module/Lambda-Function/faceprints.zip"
  tags = {
    Name = "face-prints"
    Project = "Face-Rekognition"
  }
}

##################################################################################################################################################
#                                                 Updating Lambda function Permission
##################################################################################################################################################

#Updating Lambda function permission get triggered by S3 bucket 

resource "aws_lambda_permission" "s3-trigger" {
  function_name = aws_lambda_function.face-prints.function_name
  statement_id = "InvokebyS3Object"
  action = "lambda:InvokeFunction"
  principal = "s3.amazonaws.com"
  source_arn = var.s3-bucket-arn
}