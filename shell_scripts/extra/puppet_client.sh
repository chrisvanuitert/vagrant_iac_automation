# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# SET HOSTNAME
# sudo hostnamectl set-hostname puppetclient
echo "10.0.1.10 puppetmaster puppet" | sudo tee -a /etc/hosts
echo "10.0.1.11 puppetclient" | sudo tee -a /etc/hosts

# APPLY NETWORK SETTINGS AND RESTART SYSTEMD-RESOLVED
sudo netplan generate
sudo netplan apply
sudo service systemd-resolved restart
resolvectl status

# =================================================================================================== #
# NTP CONFIGURATION
# =================================================================================================== #

# UPDATE AND INSTALL NTP + PROVDE NTP SERVER
sudo apt update
sudo apt-get -y install ntp ntpdate
sudo ntpdate -u 0.ubuntu.pool.ntp.org

# LIST AVAILABLE TIME ZONES
# timedatectl list-timezones

# SET TIME ZONE
sudo timedatectl set-timezone Europe/Amsterdam

# =================================================================================================== #
# PUPPET AGENT INSTALLATION & CONFIGURATION
# =================================================================================================== #

# INSTALL PUPPET AGENT
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt-get update
sudo apt-get -y install puppet-agent

# PUPPET CONFIGURATION
cat <<EOF | sudo tee /etc/puppetlabs/puppet/puppet.conf
[main]
server = puppet
environment = production
runinterval = 1h
[agent]
certname = puppetclient
environment = ITF
runinterval = 1h
EOF

# START AND ENABLE PUPPET
sudo systemctl start puppet
sudo systemctl enable puppet
systemctl status puppet

# FORCE UPDATE
sudo /opt/puppetlabs/bin/puppet agent --test

# IF IT USES WRONG ENVIRONMENT THEN FORCE ENVIRONMENT
sudo /opt/puppetlabs/bin/puppet agent --test --environment ITF

# LOGS
# sudo cat /var/log/puppetlabs/puppetserver

# =================================================================================================== #
# DNS INSTALLATION
# =================================================================================================== #

# CHECK INSTALLATION AFTER STEP 1
sudo systemctl status bind9
sudo dpkg -l | grep dns 

# DOWNLOAD PACKAGE
sudo wget --user=ftp --password=ftp ftp://ftp.rs.internic.net/domain/db.cache -O /etc/bind/db.root

# ZONE FILE
# sudo cat /etc/bind/named.conf
# sudo cat /etc/bind/named.conf.local

# LISTEN TO OWN DNS TO RESOLVE
cat <<EOF | sudo tee /etc/systemd/resolved.conf
[Resolve]
DNS=10.0.2.15
EOF

# RESTART DNS
sudo service systemd-resolved restart
resolvectl status

# VERIFY
# nslookup client.puppet.co