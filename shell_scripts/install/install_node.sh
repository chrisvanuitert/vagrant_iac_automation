# UDPATE PACKAGE REPOSITORY
sudo apt-get update

# INSTALL DEPENDENCIES
sudo apt-get install -y ca-certificates curl gnupg

# ADD REPOSITORY
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# INSTALL NODE
sudo apt-get install -y nodejs

# CHECK INSTALLATION
node -v
npm -v