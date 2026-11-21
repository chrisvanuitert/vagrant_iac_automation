# INSTALL COMMON SOFTWARE PROPERTIES TO MANAGE REPOSITORIES
sudo apt install -y software-properties-common

# INSTALL THE KEA DHCPV4 SERVER AND ADMINISTRATIVE TOOLS
sudo apt install -y kea-dhcp4-server kea-admin

# OVERWRITE THE KEA CONFIGURATION FILE WITH JSON-FORMATTED SETTINGS
cat <<EOF | sudo tee /etc/kea/kea-dhcp4.conf
{
  "Dhcp4": {
    # SPECIFY THE NETWORK INTERFACE KEA SHOULD LISTEN ON
    "interfaces-config": {
      "interfaces": ["enp0s3"]
    },
    # CONFIGURE THE LEASE STORAGE SYSTEM TO USE RAM-BASED STORAGE WITH PERSISTENCE
    "lease-database": {
      "type": "memfile",
      "persist": true
    },
    # SET THE DEFAULT LEASE DURATION TO 1 HOUR (3600 SECONDS)
    "valid-lifetime": 3600,
    
    # DEFINE THE SUBNET AND IP ALLOCATION PARAMETERS
    "subnet4": [
      {
        "subnet": "10.0.1.0/24",
        "pools": [
          # DEFINE THE START AND END RANGE FOR DYNAMIC IP ASSIGNMENT
          { "pool": "10.0.1.20 - 10.0.1.200" }
        ],
        # CONFIGURE DHCP OPTIONS SENT TO CLIENTS (GATEWAY AND DNS)
        "option-data": [
          { "name": "routers", "data": "10.0.1.1" },
          { "name": "domain-name-servers", "data": "8.8.8.8, 8.8.4.4" }
        ],
        # ASSIGN A FIXED IP ADDRESS TO A SPECIFIC DEVICE VIA ITS MAC ADDRESS
        "reservations": [
          {
            "hw-address": "00:11:22:33:44:55",
            "ip-address": "10.0.1.25"
          }
        ]
      }
    ]
  }
}
EOF

# RESTART THE KEA SERVICE TO APPLY THE JSON CONFIGURATION CHANGES
sudo systemctl restart kea-dhcp4-server

# ENABLE THE KEA SERVICE TO START AUTOMATICALLY WHENEVER THE SYSTEM BOOTS
sudo systemctl enable kea-dhcp4-server