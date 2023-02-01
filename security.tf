resource "aws_security_group" "kubernetes_cluster_security_group" {
  name   = "kubernetes_cluster_security_group"
  vpc_id = aws_vpc.kubernetes_cluster_vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.infrastructure_name}security_group"
  }
}

resource "aws_iam_role" "kubernetes_cluster_role" {
  name = "${var.infrastructure_name}role"
  assume_role_policy = jsonencode({
    Version = "2023-01-31"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubernetes_cluster_eks_resource_controller" {
  role       = aws_iam_role.kubernetes_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/kubernetes_cluster_eks_resource_controller"
}

resource "aws_iam_role_policy_attachment" "kubernetes_cluster_eks_policy" {
  role       = aws_iam_role.kubernetes_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/kubernetes_cluster_eks_policy"
}