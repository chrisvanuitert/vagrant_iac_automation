# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# Since ARP is non-routable, this type of scanner only works on the local LAN (local subnet or network segment.
# The ARP Scan Tool (also called ARP Sweep or MAC Scanner) is a very fast ARP). The ARP Scan Tool shows all
# active devices even if they have firewalls. Devices cannot hide from ARP packets like they can hide from
# ICPM/ping scans. 

# =============================================================================================================
# INSTALL ARP SCAN
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL ARP SCAN
sudo apt install arp-scan -y

# =============================================================================================================
# ARP SCAN COMMANDS IN LOGICAL ORDER
# =============================================================================================================

# 1 CHECK IP-NTERFACES/SUBNETS
ip a

# 2 PERFORM BASIC SCAN TO FIND ACCESSIBLE IP'S/MACS
arp-scan --interface=wlp3s0 --localnet