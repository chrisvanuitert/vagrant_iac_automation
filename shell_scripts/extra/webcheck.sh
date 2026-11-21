# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# web-check is an OSINT and reconnaissance tool. It collects a wide range of technical information about a
# target domain or website: DNS records, SSL/TLS certificates, HTTP headers, technologies in use
# (fingerprinting), open ports (Shodan integration), trackers, geolocation, and more. It’s useful for quickly
# profiling external web assets during the recon phase. Use it to build a snapshot of a website’s
# infrastructure without manual digging.

# =============================================================================================================
# INSTALL WEB-CHECK
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY 
sudo apt update

# INSTALL DEPENDENCIES
sudo apt install -y curl git build-essential traceroute dnsutils

# INSTALL NODE.JS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# VERIFY NODE.JS
node -v

# INSTALL YARN
sudo npm install -g yarn

# RETURN TO HOME DIRECTORY
cd ~

# CLONE WEB-CHECK REPOSITORY
git clone https://github.com/Lissy93/web-check.git

# GO TO FOLDER
cd web-check

# INSTALL DEPENDENCIES
yarn install

# BUILD AND RUN DETACHED
yarn build
REACT_APP_SHODAN_API_KEY="YOUR_SHODAN_API_KEY" yarn start &

# =============================================================================================================
# USE WEB-CHECK
# =============================================================================================================

# http://127.0.0.1:3000