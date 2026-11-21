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
DNS=10.0.1.10
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# TROUBLESHOOT IF WRONG DNS IS USED
cat <<EOF | sudo tee /etc/resolv.conf
nameserver 10.0.1.10
EOF

# VERIFY DNS WORKING
# resolvectl status
# nslookup www.cisco.com

# =================================================================================================== #
# CONFIGURATION FORWARD LOOKUP ZONE
# =================================================================================================== #

# CONFIGURE FORWARD LOOKUP ZONE AND CREATE DOMAIN
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "ITFlinux"{
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/ITF_linux";
};
EOF

# COPY EXISTING ZONE FILE AS STARTING POINT
sudo cp /etc/bind/db.local /etc/bind/ITF_linux
sudo chmod 644 /etc/bind/ITF_linux

# CONFIGURATION FOR ZONE FILE
cat <<'EOF' | sudo tee /etc/bind/ITF_linux
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     dns1.ITFlinux. root.ITFlinux. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      dns1.ITFlinux.
dns1      IN      A       10.0.1.10
pc1       IN      A       10.0.1.15
pc2       IN      A       10.0.1.16
pc3       IN      A       10.0.1.17
pc4       IN      A       10.0.1.18
pc5       IN      A       10.0.1.19
EOF

# RESTART DNS SERVICE & SERVER
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# VERIFY DNS
# nslookup nslookup pc1.ITFlinux

# =================================================================================================== #
# CONFIGURATION REVERSE LOOKUP ZONE
# =================================================================================================== #

# ADD REVERSE LOOKUP ZONE
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "ITFlinux"{
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/ITF_linux";
};
zone "1.0.10.in-addr.arpa" {
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/reverse_ITF_linux";
};
EOF

# MAKE REVERSE LOOKUP FILE
sudo touch /etc/bind/reverse_ITF_linux
sudo chmod 644 /etc/bind/reverse_ITF_linux

# CONFIGURATION FOR REVERSE ZONE FILE
cat <<'EOF' | sudo tee /etc/bind/reverse_ITF_linux
;
; BIND reverse data file for local loopback interface
;
$TTL    604800
@       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      dns1.ITFlinux.
10      IN      PTR     dns1.ITFlinux.
15      IN      PTR     pc1.ITFlinux.
16      IN      PTR     pc2.ITFlinux.
17      IN      PTR     pc3.ITFlinux.
18      IN      PTR     pc4.ITFlinux.
19      IN      PTR     pc5.ITFlinux.
1       IN      PTR     gateway.ITFlinux.
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# VERIFY
# nslookup 10.0.1.15

# =================================================================================================== #
# CONFIGURATION SUBZONE
# =================================================================================================== #

# CONFIGURATION FOR NEW ZONE FILE
cat <<'EOF' | sudo tee /etc/bind/ITF_linux
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     dns1.ITFlinux. root.ITFlinux. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      dns1.ITFlinux.
subzone   IN      NS      nameserver2.ITFlinux.
dns1      IN      A       10.0.1.10
pc1       IN      A       10.0.1.15
pc2       IN      A       10.0.1.16
pc3       IN      A       10.0.1.17
pc4       IN      A       10.0.1.18
pc5       IN      A       10.0.1.19
laptop1   IN      CNAME   pc1
laptop2   IN      CNAME   pc2
nameserver2   IN      A       10.0.1.11
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# VERIFY
# nslookup 10.0.1.15

# =================================================================================================== #
# CONFIGURATION ZONE TRANFERS
# =================================================================================================== #

# EDIT THE FORWARD LOOKUP ZONE FOR TRANSFER
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "ITFlinux"{
        notify yes;
        allow-transfer {any;};
        allow-update {none;};
        type master;
        file "/etc/bind/ITF_linux";
};
zone "1.0.10.in-addr.arpa" {
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/reverse_ITF_linux";
};
EOF

# CONFIGURATION FOR NEW ZONE FILE
cat <<'EOF' | sudo tee /etc/bind/ITF_linux
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     dns1.ITFlinux. root.ITFlinux. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@         IN      NS      dns1.ITFlinux.
@         IN      NS      slave
subzone   IN      NS      nameserver2.ITFlinux.

dns1      IN      A       10.0.1.10
pc1       IN      A       10.0.1.15
pc2       IN      A       10.0.1.16
pc3       IN      A       10.0.1.17
pc4       IN      A       10.0.1.18
pc5       IN      A       10.0.1.19
laptop1   IN      CNAME   pc1
laptop2   IN      CNAME   pc2
nameserver2   IN      A       10.0.1.11
slave     IN      A       10.0.1.11
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVICE & SERVER
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart 
sudo systemctl restart bind9.service

# =================================================================================================== #
# CONFIGURATION ACLS
# =================================================================================================== #

# CONFIGURE FORWARD & REVERSE LOOKUP ZONE
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "ITFlinux"{
        notify yes;
        allow-transfer {10.0.2.11;};
        allow-update {none;};
        type master;
        file "/etc/bind/ITF_linux";
};
zone "1.0.10.in-addr.arpa" {
        notify no;
        allow-update {none;};
        type master;
        file "/etc/bind/reverse_ITF_linux";
};
EOF

# APPLY NEW NETWORK SETTINGS AND RESTART DNS SERVER
sudo netplan generate
sudo netplan apply
sudo systemctl restart bind9.service

# DELETE DNS SYSTEM CACHE/VERIFY FLUSH/RESTART DNS SERVICE AFTER FLUSH
sudo resolvectl flush-caches 
sudo resolvectl statistics
sudo service systemd-resolved restart 