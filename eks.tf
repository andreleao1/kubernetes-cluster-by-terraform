resource "aws_eks_cluster" "kubernetes_cluster_eks" {
  name                      = "${var.infrastructure_name}eks"
  role_arn                  = aws_iam_role.kubernetes_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids         = aws_subnet.kubernetes_cluster_subnet[*].id
    security_group_ids = [aws_security_group.kubernetes_cluster_security_group.id]
  }
  depends_on = [
    aws_cloudwatch_log_group.kubernetes_cluster_logs,
    aws_iam_role_policy_attachment.kubernetes_cluster_eks_resource_controller,
    aws_iam_role_policy_attachment.kubernetes_cluster_eks_policy
  ]
}