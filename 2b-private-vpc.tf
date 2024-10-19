# Private VPC
resource "aws_vpc" "vpc2" {
  cidr_block = var.vpc2_cidr

  tags = {
    Name = "tf-private-vpc" # Name tag for the private VPC
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "tf-PrivateSubnet" # Name tag for the private subnet
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block         = var.vpc1_cidr                  # Route to the Public VPC via Transit Gateway
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id # Route to the Transit Gateway
  }

  tags = {
    Name = "tf-PrivateRouteTable"
  }
}


resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
