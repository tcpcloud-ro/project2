
variable "aws_vpc_name" {
  type    = string
  default = "VPC-Frontend"
}



variable "public_subnets_id" {
  description = "Public subnet for the vpc"
  type        = list(string)
  default     = []
}





