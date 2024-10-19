resource "aws_security_group" "windows_sg" {
  name   = "windows-sg"
  vpc_id = aws_vpc.vpc1.id


  # Allow RDP from anywhere
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (Ping) from anywhere
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-windows-bastion"
  }
}



###############################




resource "aws_security_group" "public_web_server" {
  name   = "public-web-server"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP from anywhere
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Ping from anywhere
  }

  # Add egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "tf-linux-public"
  }
}




###############################





resource "aws_security_group" "private_linux_sg" {
  name   = "private-linux-sg"
  vpc_id = aws_vpc.vpc2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block, aws_subnet.private_subnet.cidr_block] # HTTP from public and private subnets
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp" # Ping from Windows EC2
    cidr_blocks = [aws_subnet.public_subnet.cidr_block, aws_subnet.private_subnet.cidr_block]
  }

  # Add egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "tf-linux-private"
  }
}


##########################

resource "aws_security_group" "test_linux_sg" {
  name   = "test-linux-sg"
  vpc_id = aws_vpc.vpc3.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere
  }


  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp" # Ping from Windows EC2
    cidr_blocks = [aws_subnet.public_subnet.cidr_block, aws_subnet.private_subnet.cidr_block]
  }

  # Add egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "tf-linux-private"
  }
}
