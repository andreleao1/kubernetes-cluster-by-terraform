resource "aws_cloudwatch_log_group" "kubernetes_cluster_logs" {
  name              = "${var.infrastructure_name}logs"
  retention_in_days = var.retention_days
}
