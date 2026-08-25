#!/bin/bash

# INSTALL REQUIRED DEPENDENCIES
sudo apt install curl unzip -y

# DOWNLOAD AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# UNZIP DOWNLOADED FILE
unzip awscliv2.zip

# INSTALL AWS CLI
sudo ./aws/install

# CLEANUP INSTALLATION FILES
rm -rf awscliv2.zip aws
rm -rf aws

# VERIFY AWS CLI INSTALLATION
aws --version