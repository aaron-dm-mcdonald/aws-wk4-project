# Class 6, Week 4 Project

## Overview

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


## Setup Directions 

Working on this... 


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