# CHECK ARCHITECTURE AND DOWNLOAD THE KIND BINARY IF X86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.25.0/kind-linux-amd64

# MAKE THE KIND BINARY EXECUTABLE
chmod +x ./kind

# MOVE THE BINARY TO A SYSTEM PATH FOLDER
sudo mv ./kind /usr/local/bin/kind

# DOWNLOAD THE KUBERNETES GPG SIGNING KEY FOR SECURE PACKAGE INSTALLATION
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# SET READ PERMISSIONS ON THE KUBERNETES KEYRING
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# ADD THE KUBERNETES DEBIAN REPOSITORY TO THE SOURCES LIST
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# SET READ PERMISSIONS ON THE NEW REPOSITORY LIST FILE
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

# UPDATE THE APT PACKAGE INDEX TO INCLUDE KUBERNETES PACKAGES
sudo apt-get update

# INSTALL KUBECTL (THE COMMAND LINE TOOL FOR KUBERNETES)
sudo apt-get install -y kubectl

# CREATE A CLUSTER
# kind create cluster --name my-single-node-cluster