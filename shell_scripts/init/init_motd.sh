# DISABLE EXISTING MOTD SCRIPTS
sudo chmod -x /etc/update-motd.d/*

# CREATE FASTFETCH MOTD SCRIPT
sudo tee /etc/update-motd.d/01-fastfetch <<'EOF'
#!/bin/sh
printf "\033[H\033[2J"
echo ""
fastfetch
echo ""
EOF

# MAKE FASTFETCH MOTD SCRIPT EXECUTABLE
sudo chmod +x /etc/update-motd.d/01-fastfetch

# DISABLE MOTD NEWS
sudo tee /etc/default/motd-news <<EOF
ENABLED=0
EOF

# DISABLE SSH LAST LOGIN MESSAGE
sudo grep -q "PrintLastLog" /etc/ssh/sshd_config && \
sudo sed -i 's/.*PrintLastLog.*/PrintLastLog no/' /etc/ssh/sshd_config || \
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# RESTART SSH SERVICE
sudo systemctl restart ssh