
variable "aws_vpc_name" {
  type    = string
  default = "VPC-Frontend"
}

variable "cidr" {
  description = "The CIDR block for the VPC. "
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = [
  "us-east-1a",
  "us-east-1b",
  ]
}


variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "Frontend"
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]
}

variable "public_subnets_id" {
  description  = "Public subnet for the vpc"
  type         = list(string)
  default      = []
}


variable "public_subnet_1" {
  description = ""
}

variable "api_name" {
  
  type        = string
  description  = "Name of the API"
}

variable "env" {
  type        = string
  default     = "dev"
}




variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}




variable "default_route_table_routes" {
  description = ""
  type        = list(map(string))
  default     = []
}



variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}
variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "public_sg_ingress_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))

  default = [

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_frontend.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.vpc_frontend.ipv6_cidr_block]
  },

   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_frontend.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.vpc_frontend.ipv6_cidr_block]
  },

   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_frontend.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.vpc_frontend.ipv6_cidr_block]
  }
  ]
}

variable "public_sg_egress_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))

  default = [
   egress{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
   },
  ]
}
