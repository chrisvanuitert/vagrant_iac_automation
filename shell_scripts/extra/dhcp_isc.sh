# INSTALL THE ISC DHCP SERVER PACKAGE AUTOMATICALLY
sudo apt install isc-dhcp-server -y

# CONFIGURE THE DEFAULT INTERFACES FILE TO LISTEN ON ETH0 FOR IPV4
cat <<EOF | sudo tee /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF

# OVERWRITE THE MAIN DHCPD.CONF FILE WITH SERVER SETTINGS AND SUBNET SCOPE
cat <<EOF | sudo tee /etc/dhcp/dhcpd.conf
# DEFINE GLOBAL DOMAIN NAME AND NAMESERVERS
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

# SET DEFAULT AND MAXIMUM LEASE TIMES IN SECONDS
default-lease-time 600;
max-lease-time 7200;

# DISABLE DYNAMIC DNS UPDATES
ddns-update-style none;

# DEFINE THE SUBNET RANGE AND NETWORK OPTIONS
subnet 10.0.1.0 netmask 255.255.255.0
{
    # SPECIFY THE RANGE OF IP ADDRESSES AVAILABLE FOR CLIENTS
    range 10.0.1.100 10.0.1.160;
    
    # SPECIFY THE DEFAULT GATEWAY FOR THE CLIENTS
    option routers 10.0.1.1;
    
    # SPECIFY GOOGLE PUBLIC DNS SERVERS FOR THE CLIENTS
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    
    # ASSIGN A LOCAL DOMAIN NAME SUFFIX
    option domain-name "example.local";
}
EOF

# RESTART THE DHCP SERVER SERVICE TO APPLY THE NEW CONFIGURATION
sudo systemctl restart isc-dhcp-server.service

# ENABLE THE DHCP SERVER TO START AUTOMATICALLY ON SYSTEM BOOT
sudo systemctl enable isc-dhcp-server.service