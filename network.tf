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

resource "aws_internet_gateway" "kubernetes_cluster_internet_gateway" {
  vpc_id = aws_vpc.kubernetes_cluster_vpc.id

  tags = {
    Name = "${var.infrastructure_name}_internet_gateway"
  }
}

resource "aws_route_table" "kubernetes_cluster_route_table" {
  vpc_id = aws_vpc.kubernetes_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubernetes_cluster_internet_gateway.id
  }

  tags = {
    Name = "${var.infrastructure_name}_route_table"
  }
}

resource "aws_route_table_association" "kubernetes_cluster_route_table_association" {
  count          = 2
  route_table_id = aws_route_table.kubernetes_cluster_route_table.id
  subnet_id      = aws_subnet.kubernetes_cluster_subnet.*.id[count.index]
}