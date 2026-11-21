# INSTALL THE INTERNET SYSTEMS CONSORTIUM (ISC) DHCP CLIENT
sudo apt install isc-dhcp-client -y

# CREATE OR OVERWRITE THE NETPLAN CONFIGURATION FILE WITH DHCP SETTINGS
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF

# APPLY THE NEW NETPLAN CONFIGURATION TO THE SYSTEM
sudo netplan apply

# MANUALLY TRIGGER THE DHCP CLIENT ON INTERFACE ENP0S3 WITH VERBOSE OUTPUT
sudo dhclient -v enp0s3