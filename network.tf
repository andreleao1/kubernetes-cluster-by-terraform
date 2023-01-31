resource "aws_vpc" "kubernetes_cluster_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubernetes-vpc"
  }
}

resource "aws_subnet" "kubernetes_cluster_subnet" {
  vpc_id            = aws_vpc.kubernetes_cluster_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "kubernetes_cluster_subnet"
  }
}