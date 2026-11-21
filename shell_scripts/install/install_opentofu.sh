# INSTALL REQUIRED DEPENDENCIES
sudo apt install curl -y

# DOWNLOAD THE OPENTOFU INSTALLER
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh

# GIVE IT EXECUTE PERMISSIONS
chmod +x install-opentofu.sh

# RUN THE INSTALLER
./install-opentofu.sh --install-method deb

# REMOVE THE INSTALLER
rm -f install-opentofu.sh

# VERIFY INSTALLATION
tofu -version