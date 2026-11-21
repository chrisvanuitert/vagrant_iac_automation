# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# fping is a ping like program which uses the Internet Control Message Protocol (ICMP) echo request to
# determine if a host is up. fping is different from ping in that you can specify any number of hosts on the
# command line, or specify a file containing the lists of hosts to ping. Instead of trying one host until it
# timeouts or replies, fping will send out a ping packet and move on to the next host in a round-robin fashion.
# If a host replies, it is noted and removed from the list of hosts to check. If a host does not respond within
# a certain time limit and/or retry limit it will be considered unreachable. 

# =============================================================================================================
# INSTALL FPING
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# PROVIDE ADD-APT REPOSITORY
sudo add-apt-repository universe

# INSTALL DEPENDENCIES
sudo apt install -y software-properties-common

# UPDATE PACKAGE REPOSITORY TO INCLUDE NEW PACKAGES
sudo apt update

# INSTALL FPING
sudo apt install fping -y

# =============================================================================================================
# FPING FLAGS
# =============================================================================================================

# -a # SHOWS WHAT SYSTEMS ARE ARLIVE
# -r # RETRY LIMIT THE NUMBER OF TIMES TO ATTEMPT
# -g # GENERATE A TARGET LIST FROM SUPPLES IP
# -s # PRINT CUMULATIVE STATISTICS UPON EXIT

# =============================================================================================================
# FPING COMMANDS
# =============================================================================================================

# FPING NETWORKS
fping -a -r 0 -g 192.168.0.0/24