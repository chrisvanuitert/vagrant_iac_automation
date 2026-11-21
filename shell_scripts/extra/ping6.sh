# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# For IPv6, the standard minimum subnet size for any LAN is a /64. An IPv6 /64 allows up to 18.4 Quintillion
# host addresses. Using traditional techniques, it is impossible to scan that many addresses in a single human
# lifetime. But we have multicasting in IPv6, the address ff02::1 is a multicast address targeting all hosts on
# the link.

# =============================================================================================================
# INSTALL PING
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL PING
sudo apt install ping -y

# =============================================================================================================
# PING FLAGS
# =============================================================================================================

# -n # NO REVERSE DNS TO AVOID SLOW DOWN
# -c2 # SEND ONLY TWO PINGS BEFORE TERMINATING
# %enp0s8 # INTERFACE NOTATION

# =============================================================================================================
# PING COMMANDS IN LOGICAL ORDER
# =============================================================================================================

# 1 CHECK IP-NTERFACES/SUBNETS
ip a

# 2 PING ALL IPV6 HOSTS
ping6 -nc2 ff02::1%enp0s8