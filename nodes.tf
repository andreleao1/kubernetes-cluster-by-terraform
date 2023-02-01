resource "aws_iam_role" "kubernetes_cluster_node_role" {
  name = "${var.infrastructure_name}node_role"
  assume_role_policy = jsonencode({
    Version = "2023-01-31"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubernetes_clusterAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.kubernetes_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "kubernetes_clusterAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.kubernetes_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "kubernetes_clusterAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.kubernetes_cluster_node_role.name
}

resource "aws_eks_node_group" "node_1" {
  cluster_name    = aws_eks_cluster.kubernetes_cluster_eks.name
  node_group_name = "node_1"
  node_role_arn   = aws_iam_role.kubernetes_cluster_node_role.arn
  subnet_ids      = aws_subnet.kubernetes_cluster_subnet[*].id
  instance_types  = var.ec2_instance_type

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubernetes_clusterAmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.kubernetes_clusterAmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.kubernetes_clusterAmazonEC2ContainerRegistryReadOnly
  ]
}