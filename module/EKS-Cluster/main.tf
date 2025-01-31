################################################################################################################################################
#                                                    Deploying EKS Cluster 
################################################################################################################################################

#EKS Cluster for Face Rekognition application

resource "aws_eks_cluster" "Face-Rekognition-cluster" {
  name = "Face-Rekognition-cluster"
  role_arn = var.eks-cluster-role
  vpc_config {
    subnet_ids = [var.public-subnet-1, var.public-subnet-2]
  }
  tags = {
    Name = "Face-Rekognition-cluster"
  }
}


################################################################################################################################################
#                                                  Deploying EKS Worker Node
################################################################################################################################################

#EKS Worker Node for Face Rekognition application

resource "aws_eks_node_group" "Face-Rekognition-nodegroup" {
  node_group_name = "Face-Rekognition-nodegroup"
  cluster_name = aws_eks_cluster.Face-Rekognition-cluster.id
  subnet_ids = [var.public-subnet-1, var.public-subnet-2]
  scaling_config {
    max_size = "2"
    min_size = "1"
    desired_size = "1"
  }
  node_role_arn = var.eks-nodegroup-role
  instance_types = [ "t3.medium"]
  tags = {
    Name = "Face-Rekognition-NodeGroup"
  }
}
