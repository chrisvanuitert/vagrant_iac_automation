# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# Magicleaks is a Python3 script that checks whether a single email, or a file/list of email addresses, has
# appeared in public breaches or leak sources (Have I Been Pwned, Pastebin/paste leaks, PGP keyservers, leak
# archives, social searches, pwndb onion service, Avast Hack Check, and others). It can run in file mode,
# optionally use Tor for onion lookups, and may return related public info (usernames, possible people/data
# linked to an address).

# =============================================================================================================
# INSTALL MAGICLEAKS
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL TOR
sudo apt install tor -y

# TOR CONFIGURATION
cat <<'EOF' | sudo tee /etc/tor/torrc > /dev/null
## Minimal torrc for Magicleaks
SocksPort 9050
SocksPolicy accept 127.0.0.1
EOF

# ENABLE TOR DEFAULT SERVICE
sudo systemctl enable tor@default

# START TOR DEFAULT SERVICE
sudo systemctl start tor@default

# CHECK TOR STATUS
sudo systemctl status tor@default

# RETURN TO HOME DIRECTORY
cd ~

# CLONE MAGICLEAKS REPO LOCALLY
git clone https://github.com/magichk/magicleaks.git

# GO TO DIRECTORY
cd magicleaks

# MAKE VIRTUAL ENVIRONMENT
pyenv virtualenv 3.9.7 magicleaks-env

# ACTIVATE VIRTUAL ENVIRONMENT
pyenv activate magicleaks-env

# UPGRADE PIP TO LATEST VERSION
pip install --upgrade pip

# INSTALL REQUIREMENTS IN ENVIRONMENT
pip install -r requirements.txt

# RUN MAGIC LEAKS
python3 -m magicleaks

# =============================================================================================================
# MAGICLEAKS COMMANDS
# =============================================================================================================

# CHECK EMAIL
python3 magicleaks.py -t -e test@gmail.com