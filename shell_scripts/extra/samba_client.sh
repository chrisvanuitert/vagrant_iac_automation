# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# SET HOSTNAME (MIGHT NEED REBOOT)
# sudo hostnamectl set-hostname <name>
echo "10.0.1.10 sambaserver" | sudo tee -a /etc/hosts
echo "10.0.1.11 sambaclient" | sudo tee -a /etc/hosts

# APPLY NETWORK SETTINGS AND RESTART SYSTEMD-RESOLVED
sudo service systemd-resolved restart
resolvectl status

# =================================================================================================== #
# SAMBA CLIENT INSTALLATION
# =================================================================================================== #

# UPDATE AND INSTALL SMB CLIENT
sudo apt-get update
sudo apt-get install -y smbclient

# VERIFIY INSTALLATION
# samba -V

# DISABLE FIREWALL
sudo ufw disable

# VERIFY
sudo ufw status

# ADD THIS UNDER NETWORKING SECTION MANUALLY /etc/samba/smb.conf
# client min protocol = NT1
# server min protocol = NT1

# =================================================================================================== #
# SAMBA CLIENT COMAMNDS
# =================================================================================================== #

# LIST ALL SHARES 
# smbclient -L <server name / IP address samba server> -U <user name>
smbclient -L 10.0.1.10 -U smbuser

# REQUEST SPECIFIC SHARE
smbclient //10.0.1.10/test -U smbuser

# UPLOAD A FILE TO SAMBA
put ~/file.txt