# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# Route application network traffic through the Tor network to anonymize TCP-based tools (curl, ncat, certain
# HTTP clients and other SOCKS-capable programs). This setup installs Tor and torsocks and configures Tor to
# listen on the local SOCKS port (127.0.0.1:9050). Use torify or torsocks to “socksify” commands so their
# traffic exits via Tor circuits instead of your regular network interface.

# =============================================================================================================
# INSTALL TOR
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY
sudo apt update

# INSTALL TOR
sudo apt install tor torsocks curl -y

# ENABLE & START TOR SERVICE
sudo systemctl enable tor
sudo systemctl start tor

# TOR CONFIGURATION
cat <<'EOF' | sudo tee /etc/tor/torrc > /dev/null
## Minimal torrc for Magicleaks
SocksPort 9050
SocksPolicy accept 127.0.0.1
EOF

# RESTART TOR SERVICE
sudo systemctl restart tor

# CHECK TOR STATUS
sudo systemctl status tor

# =============================================================================================================
# TORIFY TEST
# =============================================================================================================

# SIMPLE IP TEST
curl ifconfig.me

# TORIFY IP TEST
torify curl ifconfig.me