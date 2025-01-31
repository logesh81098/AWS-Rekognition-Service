output "rekognition-collection-id-role" {
  value = aws_iam_role.rekognition-collection-id-role.arn
}

output "face-prints-role" {
  value = aws_iam_role.generate-faceprint-role.arn
}

output "eks-cluster-role" {
  value = aws_iam_role.EKS-cluster-role.arn
}

output "eks-nodegroup-role" {
  value = aws_iam_role.EKS-WorkerNode.arn
}