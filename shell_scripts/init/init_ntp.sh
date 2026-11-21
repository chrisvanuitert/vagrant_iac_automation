# INSTALL NTP
sudo apt install ntp -y

# SET THE TIMEZONE TO EUROPE/AMSTERDAM
sudo timedatectl set-timezone Europe/Amsterdam

# STOP NTP SERVICE TEMPORARILY 
sudo systemctl stop ntp

# FORCE IMMEDIATE TIME SYNCHRONIZATION 
sudo ntpd -gq

# ENABLE NTP SERVICE TO START ON BOOT
sudo systemctl enable ntp

# START NTP SERVICE IMMEDIATELY FOR TIME SYNCHRONIZATION
sudo systemctl start ntp

# VERIFY THE CURRENT TIME AND TIMEZONE STATUS
timedatectl status