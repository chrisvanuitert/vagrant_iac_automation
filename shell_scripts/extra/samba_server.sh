# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# SET HOSTNAME (MIGHT NEED REBOOT)
# sudo hostnamectl set-hostname <name>
echo "10.0.1.10 proftpd" | sudo tee -a /etc/hosts
echo "10.0.1.11 ftpclient" | sudo tee -a /etc/hosts

# APPLY NETWORK SETTINGS AND RESTART SYSTEMD-RESOLVED
sudo service systemd-resolved restart
resolvectl status

# =================================================================================================== #
# SAMBA SERVER INSTALLATION
# =================================================================================================== #

# UPDATE AND INSTALL SAMBA SERVER
sudo apt-get update
sudo apt-get install -y samba

# VERIFIY INSTALLATION
# samba -V

# MINIMAL CONFIGURATION
cat <<EOF | sudo tee /etc/samba/smb.conf
[global] # GLOBAL SETTINGS
    workgroup = WORKGROUP # WORKGROUP NAME
    server string = sambaserver # SERVER NAME
    client min protocol = NT1
    server min protocol = NT1
    # map to guest = Bad User # TELLS SERVER HOW TO HANDLE USERS THAT DON'T MATCH A UNIX ACCOUNT
    log file = /var/log/samba/%m # LOG LOCATION, %m STANDS FOR NETBIOSNAME
    max log size = 1500
[guest] # GUEST SHARES
    path = /srv/samba/guest/ # SHARE LOCATION
    read only = no
    guest ok = yes
[test] # SHARE
    path = /srv/samba/test/
    read only = no
    guest ok = no
EOF

# TEST PROGRAM FOR ERRORS
testparm /etc/samba/smb.conf

# START SAMBA
sudo service smbd start
sudo service smbd enable
sudo service smbd status

# AFTER CHANGES TO CONFIGURATION
sudo service smbd restart
sudo service nmbd restart

# CHECK CURRENT SAMBA CONNECTIONS
# sudo smbstatus
# sudo smbstatus -p
# sudo smbstatus -S
# sudo smbstatus -L

# =================================================================================================== #
# CREATE USERS
# =================================================================================================== #

# CREATE UNIX USER
sudo useradd -M -s /sbin/nologin smbuser

# SET PASSWORD FOR UNIX USER
sudo passwd smbuser

# ADD ACCOUNT TO THE SAMBA DATABASE AND SET PASSWORD
sudo smbpasswd -a smbuser

# ENABLE THE ACCOUNT IN THE SAMBA DATABASE
sudo smbpasswd -e smbuser

# CREATE LOCAL GROUP
sudo groupadd Samba_users

# ADD ACCOUNT TO THE GROUP
sudo usermod -G Samba_users smbuser

# VERIFY
# cat /etc/passwd
# cat /etc/group
# groups smbuser

# =================================================================================================== #
# CREATE SHARES
# =================================================================================================== #

# CREATE SHARE DIRECTORY
sudo mkdir -p /srv/samba/guest/
sudo mkdir -p /srv/samba/test/

# SET PERMISSIONS
sudo chown -R :Samba_users /srv/samba/guest/
sudo chown -R :Samba_users /srv/samba/test/
sudo chmod 2775 /srv/samba/guest/
sudo chmod 2770 /srv/samba/test/

# CREATE A FILE IN A SHARE
echo "Hello" | sudo tee /srv/samba/test/file.txt