################################################################################################################################################
#                                                    Deploying VPC 
################################################################################################################################################

#VPC for K8S cluster 

resource "aws_vpc" "Face-Rekogntion-VPC" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Face-Rekogntion-VPC"
  }
}

################################################################################################################################################
#                                                       Deploying Subnets 
################################################################################################################################################

resource "aws_subnet" "Face-Rekogntion-subnet-1" {
  vpc_id = aws_vpc.Face-Rekogntion-VPC.id
  cidr_block = var.public-subnet-1
  map_public_ip_on_launch = true
  availability_zone = var.az1
  tags = {
    Name = "Face-Rekogntion-subnet-1"
  }
}

resource "aws_subnet" "Face-Rekogntion-subnet-2" {
  vpc_id = aws_vpc.Face-Rekogntion-VPC.id
  cidr_block = var.public-subnet-2
  map_public_ip_on_launch = true
  availability_zone = var.az2
  tags = {
    Name = "Face-Rekogntion-subnet-2"
  }
}


################################################################################################################################################
#                                                   Deploying Internet Gateway 
################################################################################################################################################

resource "aws_internet_gateway" "Face-Rekogntion-IGW" {
  vpc_id = aws_vpc.Face-Rekogntion-VPC.id
    tags = {
    Name = "Face-Rekogntion-IGW"
  }
}


################################################################################################################################################
#                                                   Deploying Route Table
################################################################################################################################################

resource "aws_route_table" "Face-Rekogntion-RT" {
  vpc_id = aws_vpc.Face-Rekogntion-VPC.id
  route {
    gateway_id = aws_internet_gateway.Face-Rekogntion-IGW.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Face-Rekogntion-RT"
  }
}


################################################################################################################################################
#                                                   Route Table Association
################################################################################################################################################

resource "aws_route_table_association" "subnet-1" {
  subnet_id = aws_subnet.Face-Rekogntion-subnet-1.id
  route_table_id = aws_route_table.Face-Rekogntion-RT.id
}

resource "aws_route_table_association" "subnet-2" {
  subnet_id = aws_subnet.Face-Rekogntion-subnet-2.id
  route_table_id = aws_route_table.Face-Rekogntion-RT.id
}