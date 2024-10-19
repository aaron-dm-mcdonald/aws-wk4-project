resource "aws_instance" "public_web_server" {
  ami                    = var.us-east-1-linux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_web_server.id] # Use 'id' instead of 'name' dummy
  key_name               = var.ec2-key                           

  user_data = file("${path.module}/scripts/ec2startup.sh")

  tags = {
    Name = "public-web-server-1"
  }
  #depends_on = [null_resource.create_key_pair-1]  # Ensure the key pair is created before launching the instance
}


resource "aws_instance" "windows_ec2" {
  ami                    = "ami-0324a83b82023f0b3"
  instance_type          = "t2.large"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.windows_sg.id]
  key_name               = var.ec2-key

  tags = {
    Name = "public-windows-bastion"
  }
}





# EC2 instance with IAM role
resource "aws_instance" "linux_ec2" {
  ami                    = var.us-east-1-linux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_linux_sg.id]
  key_name               = var.ec2-key


  
  user_data = templatefile("${path.module}/scripts/private-startup.sh.tpl", {bucket_name = aws_s3_bucket.bucket.bucket}) # Updated path

  tags = {
    Name = "Private-web-server-1"
  }

   # Attach the IAM role
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  depends_on = [ aws_s3_object.httpd-rpm, aws_s3_bucket_policy.bucket_policy, aws_s3_bucket_public_access_block.bucket_public_access_block ]
}

# Create EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "endpoint" {

  subnet_id          = aws_subnet.private_subnet.id             # Specify the subnet where the endpoint will be created
  security_group_ids = [aws_security_group.private_linux_sg.id] # Security group for the endpoint

  tags = {
    Name = "tf-endpoint"
  }
}