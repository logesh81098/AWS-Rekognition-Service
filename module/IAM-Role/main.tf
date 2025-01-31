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


#################################################################################################################################################
#                                               Deploying IAM Role
#################################################################################################################################################

#IAM Role for EKS Cluster

resource "aws_iam_role" "EKS-cluster-role" {
  name = "EKS-cluster-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
    ]
}  
EOF
}

#################################################################################################################################################
#                                            IAM Role and Policy Attachment
#################################################################################################################################################
resource "aws_iam_role_policy_attachment" "eks-cluster-policy-1" {
  role = aws_iam_role.EKS-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-2" {
  role = aws_iam_role.EKS-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


#################################################################################################################################################
#                                               Deploying IAM Role
#################################################################################################################################################

#IAM Role for EKS Worker node

resource "aws_iam_role" "EKS-WorkerNode" {
  name = "EKS-WorkerNode"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
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

#IAM policy for EKS Cluster

resource "aws_iam_policy" "EKS-WorkerNode-Face-Rekognition-policy" {
  name = "EKS-WorkerNode-Face-Rekognition-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
    "Sid": "recognisetheimage",
    "Effect": "Allow",
    "Action": [
      "rekognition:SearchFacesByImage"
    ],
    "Resource": "arn:aws:rekognition:*:*:collection/*"
  },
  {
    "Sid": "getimagedynamoDB",
    "Effect": "Allow",
    "Action": [
      "dynamodb:GetItem"
    ],
    "Resource": "arn:aws:dynamodb:*:*:table/face-prints-table"
  },
  {
    "Sid": "accesss3bucket",
    "Effect": "Allow",
    "Action": [
      "s3:GetObject",
      "s3:PutObject"
    ],
    "Resource": "arn:aws:s3:::aws-rekognition-source-bucket-logesh81098/*"
  }
    ]
}  
EOF
}


#################################################################################################################################################
#                                            IAM Role and Policy Attachment
#################################################################################################################################################

resource "aws_iam_role_policy_attachment" "eks-workernode-1" {
  role = aws_iam_role.EKS-WorkerNode.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-workernode-cni-policy" {
  role = aws_iam_role.EKS-WorkerNode.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-container-register" {
  role = aws_iam_role.EKS-WorkerNode.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-workernode-application" {
  role = aws_iam_role.EKS-WorkerNode.id
  policy_arn = aws_iam_policy.EKS-WorkerNode-Face-Rekognition-policy.id
}