# =================================================================================================== #
# VSFTPD INSTALLATION
# =================================================================================================== #

# INSTALL VSFTPD
sudo apt-get update
sudo apt install -y vsftpd

# VERIFY 
vsftpd -v

# BACKUP CONFIGURATION FILE
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original

# BASIC CONFIGURATION
cat <<EOF | sudo tee /etc/vsftpd.conf
listen=YES

anonymous_enable=NO
# anon_root=/var/itf/ftp
# anon_upload_unable=YES

local_enable=YES
write_enable=YES
# chroot_local_user=YES
# local_root=/var/share
allow_writeable_chroot=YES

dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
EOF

# CREATE LOG FILE
sudo touch /var/log/vsftpd.log

# ENABLE PROFTPD SERVICE
sudo service vsftpd restart
service vsftpd status

# ERROR LOGS
# /usr/sbin/vsftpd /etc/vsftpd.conf
# sudo cat /var/log/vsftpd.log
# sudo journalctl -u vsftpd --no-pager | tail -20

# CREATE DIRECTORIES
sudo mkdir -p /var/itf/ftp
sudo touch root

# CHANGE HOME DIRECTORY OF THE FTP USER
sudo mkdir -p /srv/files/ftp2
sudo usermod -d /srv/files/ftp2 ftp

# RESTART PROFTPD SERVICE
sudo service vsftpd restart

# =================================================================================================== #
# CREATE FTP USER
# =================================================================================================== #

# CREATE UNIX USER
sudo useradd -M -s /sbin/nologin ftpuser

# SET PASSWORD FOR FTP USER
sudo passwd ftpuser

# TROUBLESHOOT IF LOGIN FAILS
echo "/sbin/nologin" | sudo tee -a /etc/shells
sudo mkdir -p /home/ftpuser
sudo chown ftpuser:ftpuser /home/ftpuser
sudo chmod 755 /home/ftpuser

# =================================================================================================== #
# FTPS CONFIGURATION
# =================================================================================================== #

# CREATE DIRECTORY FOR SSL/TLS KEY AND CERTIFICATE FILES
sudo mkdir -p /etc/myCerts/private

# GENERATE CERTIFICATE
sudo openssl req -x509 -nodes -keyout /etc/myCerts/private/vsftpd-selfsigned.pem -out /etc/myCerts/private/vsftpd-selfsigned.pem -days 365 -newkey rsa:2048

# CONFIGURE FIREWALL
sudo ufw allow ftp
sudo ufw allow ftps

cat <<EOF | sudo tee /etc/vsftpd.conf
listen=YES

anonymous_enable=NO
# anon_root=/var/itf/ftp
# anon_upload_unable=YES

local_enable=YES
write_enable=YES
# chroot_local_user=YES
# local_root=/var/share
allow_writeable_chroot=YES

dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd

# configure the location of the SSL certificate and key file
rsa_cert_file=/etc/myCerts/private/vsftpd-selfsigned.pem
rsa_private_key_file=/etc/myCerts/private/vsftpd-selfsigned.pem

# SSL configuration (TLS v1.2)
ssl_enable=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO

# Force Implicit FTPS
implicit_ssl=YES
listen_port=990 # or 21

# prevent anonymous users from using SSL
allow_anon_ssl=NO
# force all non-anonymous logins to use SSL for data transfer
force_local_data_ssl=YES
# force all non-anonymous logins to use SSL to send passwords
force_local_logins_ssl=YES
# Select the SSL ciphers VSFTPD will permit for encrypted SSL connections with the ssl_ciphers option.
ssl_ciphers=HIGH
# turn off SSL reuse
require_ssl_reuse=NO
EOF

# CHECK FOR SYNTAX ERRORS
# sudo /usr/sbin/vsftpd /etc/vsftpd.conf

# RESTART PROFTPD SERVICE
sudo service vsftpd restart

# =================================================================================================== #
# FTP CLIENT INSTALLATION
# =================================================================================================== #

# UPDATE AND INSTALL FTP CLIENT
sudo apt-get update
sudo apt-get install -y ftp

# CONNECT
# ftp <ip address>
# Login with <username> or <anonymous>