#!/bin/bash

# INSTALL REQUIRED DEPENDENCIES
sudo apt install curl -y

# DOWNLOAD AND INSTALL AZURE CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# VERIFY INSTALLATION
az --version