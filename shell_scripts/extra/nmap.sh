# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# Nmap (Network Mapper) is a powerful, flexible open-source network scanner used for host discovery, port
# canning, service/version detection, OS fingerprinting, and security auditing. It supports many scan types
# (TCP SYN, TCP Connect, UDP, ACK, FIN, Xmas, etc.), timing/probing controls, and an extensible scripting
# engine (NSE) for automated checks, vulnerability detection, and information gathering. Nmap is the go-to
# toolkit for network inventory, vulnerability reconnaissance, and penetration testing. Use responsibly and
# only against systems you own or are authorized to test.

# =============================================================================================================
# INSTALL NMAP
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL NMAP
sudo apt install nmap -y

# =============================================================================================================
# COMMON FLAGS SUMMARY
# =============================================================================================================

# -sS : TCP SYN scan (stealth; requires root)
# -sT : TCP connect scan (no root)
# -sU : UDP scan
# -p : ports
# -sV : service/version detection
# -O : OS detection
# -A : enable -sV, -O, --script, traceroute
# -Pn : skip host discovery
# -sn : ping/host discovery only
# -T<0-5>: timing template (0 slowest - 5 fastest)
# --script: specify NSE scripts or categories
# -oA : output all formats (normal + XML + grepable)
# -oG : grepable output
# -v/-vv : verbose

# =============================================================================================================
# NMAP COMMANDS
# =============================================================================================================

# CHECK IP-NTERFACES/SUBNETS
ip a

# PING NETWORK WITHOUT PORT SCAN (HOST DISCOVERY)
nmap -sn 192.168.0.0/24

# PORT SCANS
nmap -p 22,80,443 192.168.0.10
nmap -p 1-1000 192.168.0.10

# SCAN TOP USED PORTS FOR IP
nmap --top-ports 100 192.168.0.10

# SERVICE DETECTION ON NETWORK
nmap -sV -p 1-65535 192.168.0.0/24

# OS DETECTION OF IP
nmap -O 192.168.0.10
nmap -A 192.168.0.10
nmap -A google.com

# FAST SCAN (MAY BE NOISY)
nmap -T4 192.168.0.0/24

# SLOW SCAN (LESS LIKELY TO TRIGGER IDS)
nmap -T2 192.168.0.0/24

# =============================================================================================================
# NMAP SCRIPTS
# =============================================================================================================

# SEARCH FOR VULNERABLE SERVERS
nmap -sC -p 445 --script smb-vuln-ms17-010.nse 192.168.1.0/24