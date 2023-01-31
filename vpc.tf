resource "aws_vpc" "kubernetes-cluster" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubernetes-vpc"
  }
}