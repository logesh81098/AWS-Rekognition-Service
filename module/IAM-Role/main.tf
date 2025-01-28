#################################################################################################################################################
#                                               Deploying IAM Role
#################################################################################################################################################

#IAM Role for lambda function to create AWS Rekognition collection ID

resource "aws_iam_role" "rekognition-collection-id-role" {
  name = "rekognition-collection-id-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }    
    ]
}  
EOF
}


#################################################################################################################################################
#                                               Deploying IAM Policy
#################################################################################################################################################

#IAM Policy for Lambda function to create AWS Rekognition collection ID

resource "aws_iam_policy" "rekognition-collection-id-policy" {
  name = "rekognition-collection-id-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid": "CollectingRekognition",
        "Effect": "Allow",
        "Action": [
            "rekognition:CreateCollection",
            "rekognition:DeleteCollection",
            "rekognition:ListCollections"
        ],
        "Resource": "*"
    },
    {
        "Sid": "CloudWatchLogGroup",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    }
    ]
}  
EOF
}

#################################################################################################################################################
#                                            IAM Role and Policy Attachment
#################################################################################################################################################

resource "aws_iam_role_policy_attachment" "rekognition-collection-id" {
  role = aws_iam_role.rekognition-collection-id-role.id
  policy_arn = aws_iam_policy.rekognition-collection-id-policy.arn
}

#################################################################################################################################################
#                                               Deploying IAM Role
#################################################################################################################################################

#IAM Role for lambda function to collect and store Face prints in DynamoDB table
resource "aws_iam_role" "generate-faceprint-role" {
  name = "generate-faceprint"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
    ]
}  
EOF
}

#################################################################################################################################################
#                                               Deploying IAM Policy
#################################################################################################################################################

#IAM policy for lambda function to collect and store Face prints in DynamoDB table

resource "aws_iam_policy" "generate-faceprint-policy" {
  name = "generate-faceprint"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid": "CloudWatchLogGroup",
        "Effect" : "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Sid": "PutItemsInDynamoDB",
        "Effect": "Allow",
        "Action": [
            "dynamodb:PutItem"
        ],
        "Resource": "arn:aws:dynamodb:*:*:table/face-prints-table"
    },
    {
        "Sid": "IndexFaceRekognitionID",
        "Effect": "Allow",
        "Action": [
            "rekognition:IndexFaces"
        ],
        "Resource": "arn:aws:rekognition:*:*:collection/*"
    },
    {
        "Sid": "FetchImagesFromS3",
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:HeadObject"
        ],
        "Resource": "arn:aws:s3:::peoples-source-image/*"
    }
    ]
}  
EOF
}


#################################################################################################################################################
#                                            IAM Role and Policy Attachment
#################################################################################################################################################

resource "aws_iam_role_policy_attachment" "face-prints" {
  role = aws_iam_role.generate-faceprint-role.id
  policy_arn = aws_iam_policy.generate-faceprint-policy.arn
}