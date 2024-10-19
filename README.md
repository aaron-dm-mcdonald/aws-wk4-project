# Class 6, Week 4 Project

## Infrastructure Overview

This infrastructure (using AWS) contains the following:
- Network Infrastructure 
    - Two VPCs 
        - Each VPC has one subnetwork 
        - One VPC (10.10/16) contains an internet gateway default route
        - One VPC (10.15/16) is entirely private (no NAT as well)
    
    - One Internet Gateway (for 10.10/16)
    - Respective Route Tables
    - One Transit Gateway (containing two attachments to both VPCs)
- Security Rules
    - Each EC2 has a respective Security Group. 
    - The Public web server has protocols for HTTP, SSH, and ICMP
    - The Private web server has protocols for HTTP, SSH, and ICMP
        - Excluding SSH (which can only be accesssed via EC2 connect endpoint), the CIDR ranges are restricted to private traffic here
    - The windows Bastion Host Security Group that contains RDP from anywhere plus ICMP (from private ranges only)
- EC2 Instances
   - Linux: standard configurations for both EC2 instances excluding:
        - Public Web Server: A simple startup script showing metadata is used. httpd is installed. 
        - Private Web Server: Has S3 endpoint gateway and IAM roles to access S3. Contains a startup script for local install of httpd.
   - Windows: A single bastion host with no further configuration except it utilizes a t2.large machine type for the performance requirements of windows   

## Configuration Overview
1) We need to get needed packages for apache2 for an instance with no internet access
    - We will make an S3 bucket and add IAM permissons for the EC2
    - Terraform will upload these packages into the S3 bucket 
    - Finally ```yum localinstall``` and ```aws s3 cp``` will be used to get the packages to the EC2 instance 

2) We will need to create a key pair for all EC2 instances 

3) We will show the transit gateway's functionality using the windows bastion host to access the private web server

## Setup Directions 

1) Clone Repo
    - Open a terminal and run: ```git clone https://github.com/aaron-dm-mcdonald/aws-wk4-project.git```
    - Open the directory that is created: ```cd aws-wk4-project```
    - Open VS Code: ```code .```

2) Generate a key pair (might be unneeded if you have one you want to use or the provisoner starts to work)
    - ```aws ec2 create-key-pair --key-name tf-key-test --query 'KeyMaterial' --output text  > tf-key-test.pem --region us-east-1```

3) Download needed packages for RPM
    - Make the script executable: ```chmod +x scripts/download-httpd.sh```
    - Execute the script: ```./scripts/download-httpd.sh```
    - Verify a directory called 'rpm_packages' is created in your working directory

4) Time to run Terraform
    - Initalize terraform and needed providers: ```terraform init```
    - Generate execution plan: ```terraform plan```
    - Apply the configuration: ```terraform apply -auto-approve```
    - Verify Infrastructure creation: ```terraform state list```


## Project Structure

- ./
    - .gitignore
    - 0-var.tf
    - 1-auth.tf
    - 2a-public-vpc.tf
    - 2b-private-vpc.tf
    - 3-tgw.tf
    - 4-sg.tf
    - 5-ec2.tf
    - 6-s3.tf
    - 7-iam.tf
    - 8-outputs.tf    
    - repo/
        - push.sh
        - readme.py
    - scripts/
        - download-httpd.sh
        - ec2startup.sh
        - private-startup.sh.tpl