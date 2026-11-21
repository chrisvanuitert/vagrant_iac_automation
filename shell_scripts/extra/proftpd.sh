# =================================================================================================== #
# PROFTPD SERVER INSTALLATION
# =================================================================================================== #

# UPDATE AND INSTALL PROFTPD SERVER
sudo apt-get update
sudo apt-get install -y proftpd

# VERIFIY INSTALLATION
sudo proftpd -v
sudo proftpd -vv

# ENABLE PROFTPD SERVICE
sudo systemctl start proftpd
sudo systemctl enable proftpd
sudo systemctl status proftpd

# CONFIGURATION FILE
# sudo nano /etc/proftpd/proftpd.conf

# BACKUP CONFIGURATION FILE
sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.original

# CONFIGURATION
cat <<EOF | sudo tee /etc/proftpd/proftpd.conf
ServerName              "ProFTPD Linux"
ServerType              standalone
DefaultServer           on
DisplayLogin            welcome.msg
DisplayChdir            .message
RequireValidShell       off
Port                    21
Umask                   022 022
MaxInstances            30
User                    proftpd
Group                   nogroup
# DefaultRoot           ~
# SyslogLevel           INFO

<Directory />
  AllowOverwrite        on
</Directory>

<Anonymous ~ftp>
  User                  ftp
  Group                 ftp
  RequireValidShell     off
  UserAlias             anonymous ftp
  MaxClients            10
  DisplayLogin          welcome.msg
  DisplayChdir          .message
  <Limit WRITE>
    DenyAll
  </Limit>
</Anonymous>
EOF

# PAM CONFIGURATION
cat <<EOF | sudo tee /etc/pam.d/proftpd
#%PAM-1.0
auth    required        pam_unix.so nullok
account required        pam_unix.so
session required        pam_unix.so
EOF

# WELCOME MESSAGE
cat <<EOF | sudo tee /srv/ftp/welcome.msg
Hello From FTP!
EOF

# CHECK CONFIGURATION SYNTAX
sudo proftpd -t

# RESTART PROFTPD SERVICE
sudo systemctl restart proftpd

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
# FTP CLIENT INSTALLATION
# =================================================================================================== #

# UPDATE AND INSTALL FTP CLIENT
sudo apt-get update
sudo apt-get install -y ftp

# CONNECT
# ftp <ip address>
# Login with <username> or <anonymous>