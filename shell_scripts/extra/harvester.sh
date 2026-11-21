# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# theHarvester queries multiple public sources (search engines, PGP keyservers, certificate transparency,
# Netcraft, etc.) to collect email addresses, subdomains, hostnames, IPs, open ports/banners, employee names
# and URLs related to a target domain. Use it for passive and (some) active discovery to build an inventory of
# externally visible assets for a target organization.

# =============================================================================================================
# INSTALL HARVESTER
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL DEPENDENCIES
sudo apt install -y git build-essential python3 python3-venv python3-pip python3-dev libssl-dev libffi-dev

# RETURN TO HOME DIRECTORY
cd ~

# CLONE HARVESTER REPO LOCALLY
git clone https://github.com/laramies/theHarvester.git

# GO TO DIRECTORY
cd theHarvester

# MAKE VIRTUAL ENVIRONMENT
pyenv virtualenv 3.12.6 harvester-env

# ACTIVATE VIRTUAL ENVIRONMENT
pyenv activate harvester-env

# UPGRADE PIP TO LATEST VERSION
pip install --upgrade pip

# INSTALL REQUIREMENTS IN ENVIRONMENT
pip install .

# ADD API KEYS
cat <<'EOF' | sudo tee ~/theHarvester/theHarvester/data/api-keys.yaml > /dev/null
yaml 
apikeys:
  bevigil:
    key:
  brave:
    key:
  bufferoverun:
    key:
  builtwith:
    key:
  censys:
    id:
    secret:
  criminalip:
    key:
  dehashed:
    key:
  dnsdumpster:
    key:
  fullhunt:
    key:
  github:
    key:
  haveibeenpwned:
    key:
  hunter:
    key:
  hunterhow:
    key:
  intelx:
    key:
  leaklookup:
    key:
  netlas:
    key:
  onyphe:
    key:
  pentestTools:
    key:
  projectDiscovery:
    key:
  rocketreach:
    key:
  securityscorecard:
    key:
  securityTrails:
    key:
  shodan:
    key:
  tomba:
    key:
    secret:
  venacus:
    key:
  virustotal:
    key:
  whoisxml:
    key:
  zoomeye:
    key:
EOF

# RUN THE HARVESTER
theHarvester -h

# =============================================================================================================
# HARVESTER COMMANDS
# =============================================================================================================

# RUN A HARVEST
theHarvester -d domain.com -b duckduckgo