# S3 Bucket Definition
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "package-storage"
  force_destroy = true

  tags = {
    Name = "package-storage"
  }
}




# Upload RPM files from the local directory to the S3 bucket
resource "aws_s3_object" "httpd-rpm" {
  for_each = fileset("${path.module}/rpm_packages/", "*.rpm")  # Adjust the path to your rpm_packages directory

  bucket = aws_s3_bucket.bucket.id
  key    = "httpd/${each.value}"  # Specify the prefix (folder) in the key
  source = "${path.module}/rpm_packages/${each.value}"
}





# S3 VPC Endpoint for Private Access
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id           = aws_vpc.vpc2.id
  service_name     = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # Associate with the route tables of the private subnet(s)
  route_table_ids = [aws_route_table.private_route_table.id]

  tags = {
    Name = "S3Endpoint"
  }
}
