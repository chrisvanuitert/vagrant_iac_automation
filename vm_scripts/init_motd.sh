#!/bin/bash

# DISABLE UNNECESSARY MOTD COMPONENTS
sudo chmod -x /etc/update-motd.d/*

# CLEAR SCREEN AND DISPLAY FASTFETCH
sudo tee /etc/update-motd.d/01-fastfetch <<'EOF'
#!/bin/sh
printf "\033[H\033[2J"
echo ""
fastfetch
echo ""
EOF

# MAKE THE SCRIPT EXECUTABLE
sudo chmod +x /etc/update-motd.d/01-fastfetch

# DISABLE NEWS COMPONENTS
sudo tee /etc/default/motd-news <<EOF
ENABLED=0
EOF

# DISABLE LAST LOG INFORMATION
sudo grep -q "PrintLastLog" /etc/ssh/sshd_config && \
sudo sed -i 's/.*PrintLastLog.*/PrintLastLog no/' /etc/ssh/sshd_config || \
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart ssh