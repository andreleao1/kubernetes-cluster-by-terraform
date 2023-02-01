variable "infrastructure_name" {
  type = string
}

variable "default_region" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "ec2_instance_type" {
  type    = list(any)
  default = ["t2.micro"]
}
