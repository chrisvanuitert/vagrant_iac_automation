# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# nslookup is a simple DNS query utility used to perform name-to-IP and IP-to-name lookups and to query
# specific. DNS servers for records (A, AAAA, MX, TXT, NS, SOA, etc.). It's useful for quick DNS
# troubleshooting and basic OSINT recon to verify DNS entries or examine DNS responses from particular
# resolvers. 

# =============================================================================================================
# INSTALL DNS UTILS
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL DNS UTILS
sudo apt install dns-utils -y

# =============================================================================================================
# NSLOOKUP COMMAND
# =============================================================================================================

# TRANSLATE DOMAIN TO IP ADDRESS
nslookup google.com

# TRANSLATE IP ADDRESS TO DOMAIN
nslookup 8.8.8.8