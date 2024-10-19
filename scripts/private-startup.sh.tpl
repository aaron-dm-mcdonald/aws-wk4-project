#!/bin/bash

# Define the directory for RPMs
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

# Create a basic web page
sudo echo '<html><body><h1>Welcome to My Web Server!</h1><p>Powered by Amazon Linux & HTTPD</p></body></html>' | sudo tee /var/www/html/index.html

# Set the correct permissions
sudo chmod 644 /var/www/html/index.html

# Clean up downloaded RPMs if desired
 rm -f *.rpm

