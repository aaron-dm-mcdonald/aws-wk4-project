#!/bin/bash

# Define the directory for RPM artifacts for httpd package
RPM_DIR="/tmp/httpd"

# Create the RPM_DIR if it does not exist
mkdir -p $RPM_DIR

# Fetch all the RPM packages from the specified folder in the S3 bucket
aws s3 cp s3://${bucket_name}/httpd/ $RPM_DIR/ --recursive

# Change to the directory with the RPM files
cd $RPM_DIR

# Use yum to install all the RPM packages in the directory
sudo yum localinstall -y *.rpm

# Start the httpd service
sudo systemctl start httpd
sudo systemctl enable httpd

# Clean up downloaded RPMs if desired
rm -f *.rpm

# Configure and retrieve metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$${macid}/vpc-id)

# Create a basic HTML page with instance metadata
echo "
<!doctype html>
<html lang=\"en\" class=\"h-100\">
<head>
<title>Details for EC2 instance</title>
</head>
<body>
<div>
<h1>AWS Instance Details</h1>
<h1>Samurai Katana</h1>


<p><b>Instance Name:</b> \$(hostname -f) </p>
<p><b>Instance Private IP Address:</b> \$${local_ipv4}</p>
<p><b>Availability Zone:</b> \$${az}</p>
<p><b>Virtual Private Cloud (VPC):</b> \$${vpc}</p>
</div>
</body>
</html>
" > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
