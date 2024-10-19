resource "null_resource" "log_all" {
  provisioner "local-exec" {
    command = <<EOF
      echo "----- Starting Terraform Run: "figure how to insert date here" -----" >> log.txt

      cat <<EOT >> log.txt
      
      SAMPLE LOG INFO
      Additional details can be added here.
      
      EOT
  EOF
      
    
  }
}



##################################


# Key Pair Managment (I'm confident I did this the most roundabout way possible)

# resource "null_resource" "create_key_pair" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws ec2 create-key-pair --key-name tf-key --query 'KeyMaterial' --output text  > tf-key.pem --region ${var.region}
#       chmod 400 tf-key.pem
#     EOT
#   }

#  trigger to ensure this runs only once
#   triggers = {
#     key_pair_name = "tf-key"
#   }
# }
