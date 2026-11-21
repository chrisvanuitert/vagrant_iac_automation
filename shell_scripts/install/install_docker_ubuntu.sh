# INSTALL REQUIRED DEPENDENCIES
sudo apt install curl gpg -y

# DOWNLOAD AND SAVE DOCKER GPG KEY
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# ADD DOCKER REPOSITORY TO APT SOURCES
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# UPDATE REPOSITORY TO INCLUDE DOCKER PACKAGES
sudo apt update

# INSTALL DOCKER ENGINE, CLI, RUNTIME, BUILDX AND COMPOSE
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# ADD VAGRANT USER TO DOCKER GROUP
sudo usermod -aG docker vagrant

# APPLY NEW GROUP MEMBERSHIP IMMEDIATELY
newgrp docker

# CONFIGURE DOCKER DNS SERVERS
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
EOF

# RESTART DOCKER TO APPLY NEW DNS SETTINGS
sudo systemctl restart docker

# VERIFY INSTALLATION
docker --version