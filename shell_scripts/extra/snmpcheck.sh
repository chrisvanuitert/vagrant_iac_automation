# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# snmpcheck.sh is a shell script that queries SNMP-enabled devices to enumerate system information, network
# configuration, interfaces, routing tables, and other data exposed via SNMP. It’s useful for auditing devices
# that still have default or weak SNMP community strings (e.g. “public”). Works against SNMPv1 and v2c targets.
# Use it only on systems you are authorized to test, since SNMP often reveals sensitive details about a host.

# =============================================================================================================
# INSTALL SNMPCHECK
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL SNMP UTILITIES
sudo apt install snmp git -y

# DOWNLOAD SNMPCHECK SCRIPT
wget https://raw.githubusercontent.com/takeshixx/snmpcheck/master/snmpcheck.sh

# GO TO DIRECTORY
cd snmpcheck

# MAKE SCRIPT EXECUTABLE
chmod +x snmpcheck.sh

# RUN EXAMPLE
./snmpcheck.sh -t 192.168.0.10 -c public