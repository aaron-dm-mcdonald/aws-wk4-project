# output "windows_ec2_public_ip" {
#   value = aws_instance.windows_ec2.public_ip
# }

# output "linux_ec2_private_ip" {
#   value = aws_instance.linux_ec2.private_ip
# }


# Key Pair Managment (I'm confident I did this the most roundabout way possible)

# resource "null_resource" "create_key_pair" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws ec2 create-key-pair --key-name tf-key --query 'KeyMaterial' --output text  > tf-key.pem --region ${var.region}
#       chmod 400 tf-key.pem
#     EOT
#   }

# Optional: trigger to ensure this runs only once
#   triggers = {
#     key_pair_name = "tf-key"
#   }
# }
