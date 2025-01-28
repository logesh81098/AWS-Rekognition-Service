##################################################################################################################################################
#                                                   Archive the source code
##################################################################################################################################################

#Archive the python code file into Zip file so that Lambda function can work on it 
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
