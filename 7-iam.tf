resource "aws_iam_role" "ec2_role" {
  name = "EC2_S3_Access_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2_S3_Access_Profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Attach the AWS managed policy
}
