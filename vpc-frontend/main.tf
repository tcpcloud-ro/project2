resource "aws_vpc" "vpc_frontend" {

  name = "vpc-frontend"
  cidr = "10.0.0.0/16"

  azs             = "us-east-1a"
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_support = true

  ### Subnet 1 ###
  resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc_frontend.id
  cidr_block = "10.0.101.0/24"

  tags = {
    Name = "subnet 1"
  }
}
  ### Subnet 2 ###
  resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc_frontend.id
  cidr_block = "10.0.102.0/24"

  tags = {
    Name = "subnet 2"
  }

  ### SG ###
  resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_frontend.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_frontend.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.vpc_frontend.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg frontend"
  }
}
  ### Default NACL ###
  resource "aws_default_network_acl" "nacl_frontend" {
  vpc_id =  aws_vpc.vpc_frontend.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  }

  ### IGW ###
  resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_frontend.id

  tags = {
    Name = "main"
  }
  } 

  resource "aws_internet_gateway_attachment" "" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc_frontend.id
  }

  ###  Route  ###
resource "aws_route" "frontend" {
  route_table_id            = aws_route_table.route_table_frontend.id
  destination_cidr_block    = "10.0.0.0/24"
  internet_gateway_id       = aws_internet_gateway.igw.id
}
###  Route Table ###
resource "aws_route_table" "route_table_frontend" {
  vpc_id = aws_vpc.vpc_frontend.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
###  Route Table Association a ###
  resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.bar.id
}
###  Route Table Association b ###
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table_frontend.id
}

resource "aws_network_interface" "ni_frontend" {
  subnet_id       = aws_subnet.public_frontend.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.web.id]

  attachment {
    instance     = aws_instance.test.id
    device_index = 1
  }
}

}