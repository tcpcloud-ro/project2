resource "aws_vpc" "vpc_frontend" {

  name = local.vpc_name
  
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.101.0/24","10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_support = true

  ### Public subnet A ###
  resource "aws_subnet" "public_subnet_A" {
  vpc_id     = aws_vpc.vpc_frontend.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  }
 
   ### Public subnet B ###
  resource "aws_subnet" "public_subnet_B" {
  vpc_id     = aws_vpc.vpc_frontend.id
  cidr_block = "10.0.102.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  }

  ### SG ###
  resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_frontend.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"
  },

  ingress {
     description      = "HTTP"
     from_port        = 80
     to_port          = 80
     protocol         = "tcp"
  },

   ingress {
     description      = "SSH"
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
  },

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
}

  ### IGW ###
  resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_frontend.id
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