resource "aws_vpc" "vpc_frontend" {

  name = var.aws_vpc_api
  cidr = var.cidr_block

  azs             = var.azs
  public_subnets  = var.public_subnets 

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_support = true

  ### Define public subnets ###
  resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_frontend.id
  cidr_block = "${element(var.public_subnet_cidr_blocks, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"


  tags = {
    Name = "subnet 1"
  }
  }

  ### SG ###
  resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_frontend.id

  ingress     = var.public_sg_ingress_rules
  egress      = var.public_sg_egress_rules

  tags = {
    Name = "sg frontend"
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
}

###  Route Table Association a ###
  resource "aws_route_table_association" "default_public_route" {
  count = 2
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.default_public_route.id}"
}



}