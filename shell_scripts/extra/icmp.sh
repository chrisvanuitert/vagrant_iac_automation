# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# A ping sweep iterates through an IP range and sends ICMP echo requests to each address to determine which
# hosts are up.

# =============================================================================================================
# INSTALL PING
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL PING
sudo apt install ping -y

# =============================================================================================================
# PING COMMANDS IN LOGICAL ORDER
# =============================================================================================================

# 1 CHECK IP-NTERFACES/SUBNETS
ip a

# 2 PERFORM BASIC PING LOOP
for ip in $(seq 1 10); do ping -c 1 10.0.0.$ip | head -n 2; done

# 3 PERFORM PING LOOP WITH BETTER OUTPUT (DON'T DO TOO MANY AT ONCE)
for ip in $(seq 1 10); do
  if ping -c 1 -W 1 -q 10.0.0.$ip >/dev/null 2>&1; then
    echo "10.0.0.$ip is up"
  fi
done