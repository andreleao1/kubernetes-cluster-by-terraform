resource "aws_vpc" "kubernetes_cluster_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.infrastructure_name}vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "kubernetes_cluster_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.kubernetes_cluster_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.infrastructure_name}subnet_${count.index}"
  }
}