# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# UPDATE AND INSTALL BIND9 DNS SERVER
sudo apt update
sudo apt install bind9 -y
sudo apt install dnsutils -y

# VERIFY INSTALLATION
# named -v

# CONFIGURATION FILES:
# /etc/bind/named.conf.local
# /etc/bind/named.conf.options
# /etc/bind/named.conf.default-zones

# ZONE FILES FROM ZONE TRANSFERS:
# /var/cache/bind

# DEFINES GLOBAL DNS SERVER
cat <<EOF | sudo tee /etc/systemd/resolved.conf
[Resolve]
DNS=10.0.1.11
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# TROUBLESHOOT IF WRONG DNS IS USED
cat <<EOF | sudo tee /etc/resolv.conf
nameserver 10.0.1.11
EOF

# VERIFY DNS WORKING
# resolvectl status
# nslookup www.cisco.com

# =================================================================================================== #
# CONFIGURATION SUBZONE
# =================================================================================================== #

# CONFIGURE FORWARD LOOKUP ZONE FOR SUB-ZONE
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "subzone.ITFlinux" IN {
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/subzone_ITF_linux";
};
EOF

# MAKE SUB-ZONE FILE
sudo touch /etc/bind/subzone_ITF_linux
sudo chmod 644 /etc/bind/subzone_ITF_linux

# CONFIGURATION FOR ZONE FILE
cat <<'EOF' | sudo tee /etc/bind/subzone_ITF_linux
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     dns2.subzone.ITFlinux. root.subzone.ITFlinux. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      dns2.subzone.ITFlinux.
dns2      IN      A       10.0.1.11
pc6       IN      A       10.0.1.20
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# =================================================================================================== #
# CONFIGURATION ZONE TRANSFERS
# =================================================================================================== #

# CREATE FILE FOR LOGGING
sudo touch /var/log/named.run
sudo chmod 644 /var/log/named.run
sudo chown bind:bind /var/log/named.run

# APPARMOR MIGHT BLOCK LOGGING
sudo nano /etc/apparmor.d/usr.sbin.named

# UNDER LOGGING SECTION ADD
/var/log/named.run rw,

# RESTART APPARMOR
sudo systemctl reload apparmor

# CONFIGURE FORWARD LOOKUP ZONE
cat <<EOF | sudo tee /etc/bind/named.conf.local
logging {
        channel default_debug {
        file "/var/log/named.run";
        severity dynamic;
        };
};
zone "ITFlinux" IN {
        type slave;
        file "auto_ITF_linux";
        masters { 10.0.1.10; };
};
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# CHECK IF COPY OF ZONE FILE IS ON SLAVE
# ls /var/log/syslog
# ls /var/cache/bind
# cat /var/log/named.run