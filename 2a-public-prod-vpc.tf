# Public Facing VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc1_cidr

  tags = {
    Name = "tf-prod-vpc" # Name tag for the VPC
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-PublicSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "tf-MyInternetGateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc1.id

  # Route for Internet traffic
  route {
    cidr_block = "0.0.0.0/0"                 # Route all outbound traffic to the Internet
    gateway_id = aws_internet_gateway.igw.id # Route to the Internet Gateway
  }

  # Route to the Private VPC via Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"                       # Route to the Private VPC via Transit Gateway
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id # Route to the Transit Gateway
  }

  tags = {
    Name = "tf-PublicRouteTable"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}




