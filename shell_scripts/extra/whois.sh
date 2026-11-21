# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# whois is a command-line utility and network protocol used to query WHOIS databases that store registration
# details about domain names and IP address allocations. It retrieves information such as registrar, registrant
# contact details (if not privacy-protected), name servers, registration/expiration dates, and administrative/
# technical contacts. Whois lookups are fundamental during OSINT and recon to understand ownership and history
# of a domain or IP block.

# =============================================================================================================
# INSTALL WHOIS
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL WHOIS
sudo apt install whois -y

# =============================================================================================================
# SCIPT WHOIS
# =============================================================================================================

#!/usr/bin/env bash
set -euo pipefail

read -rp "Enter domain (e.g. example.com): " domain
domain="${domain##*( )}"
domain="${domain%%*( )}"

if [[ -z "$domain" ]]; then
  echo "No domain provided. Exiting." >&2
  exit 1
fi

if ! command -v whois >/dev/null 2>&1; then
  echo "whois is not installed. Install it with: sudo apt install whois" >&2
  exit 2
fi

echo "Running whois for: $domain"
whois "$domain"

# =============================================================================================================
# HOW TO RUN
# =============================================================================================================

# GIVE PERMISSIONS
# sudo chmod +x whois.sh

# EXECUTE SHELL SCRIPT
# sudo ./whois.sh

# FILL IN DOMAIN WHEN PROMPTED