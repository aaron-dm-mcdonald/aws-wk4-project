# Private VPC
resource "aws_vpc" "vpc3" {
  cidr_block = var.vpc3_cidr

  tags = {
    Name = "tf-test-vpc" # Name tag for the private VPC
  }
}

resource "aws_subnet" "private_test_subnet" {
  vpc_id     = aws_vpc.vpc3.id
  cidr_block = var.private_test_subnet_cidr

  tags = {
    Name = "tf-PrivateSubnet" # Name tag for the private subnet
  }
}

resource "aws_subnet" "public_test_subnet" {
  vpc_id     = aws_vpc.vpc3.id
  cidr_block = var.public_test_subnet_cidr

  tags = {
    Name = "tf-PublicSubnet" # Name tag for the private subnet
  }
}







# Create and Attach an Internet Gateway
resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc3.id  

  tags = {
    Name = "tf-InternetGateway"
  }
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"  

  tags = {
    Name = "tf-NAT-EIP"
  }
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_test_subnet.id  # Reference your Public Subnet

  depends_on = [aws_internet_gateway.igw]  # Ensure IGW is created first

  tags = {
    Name = "tf-NAT-Gateway"
  }
}




# Private Route Table with NAT Gateway Route
resource "aws_route_table" "test_private_route_table-1" {
  vpc_id = aws_vpc.vpc3.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "tf-PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_subnet_association-1" {
  subnet_id      = aws_subnet.private_test_subnet.id
  route_table_id = aws_route_table.test_private_route_table-1.id
}














resource "aws_route_table" "test_public_route_table" {
  vpc_id = aws_vpc.vpc3.id

  route {
    cidr_block         = "10.0.0.0/8"                   # Route to the Public VPC via Transit Gateway
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id # Route to the Transit Gateway
  }

  route {
    cidr_block = "0.0.0.0/0"                   # Route all outbound traffic to the Internet
    gateway_id = aws_internet_gateway.igw-1.id # Route to the Internet Gateway
  }

  tags = {
    Name = "tf-PublicRouteTable"
  }
}


resource "aws_route_table_association" "test_public_subnet_association" {
  subnet_id      = aws_subnet.public_test_subnet.id
  route_table_id = aws_route_table.test_public_route_table.id
}
