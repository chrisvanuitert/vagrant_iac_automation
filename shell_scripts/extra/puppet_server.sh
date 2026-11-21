# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# SET HOSTNAME (MIGHT NEED REBOOT)
# sudo hostnamectl set-hostname puppetmaster
echo "10.0.1.10 puppetmaster puppet" | sudo tee -a /etc/hosts
echo "10.0.1.11 puppetclient" | sudo tee -a /etc/hosts

# DEFINES GLOBAL DNS SERVER
cat <<EOF | sudo tee /etc/systemd/resolved.conf
[Resolve]
DNS=8.8.8.8
EOF

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
# PUPPET SERVER INSTALLATION & CONFIGURATION
# =================================================================================================== #

# INSTALL PUPPET SERVER
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt update
sudo apt install -y puppetserver

# START AND ENABLE SERVER
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
systemctl status puppetserver

# SETTINGS FOR PUPPET (CHANGE RAM TO 1GB TO AVOID CRASH)
cat <<EOF | sudo tee /etc/default/puppetserver
###########################################
# Init settings for puppetserver
###########################################
# Location of your Java binary (version 8)
JAVA_BIN="/usr/bin/java"
# Modify this if you'd like to change the memory allocation, enable JMX, etc
JAVA_ARGS="-Xms1g -Xmx1g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"
# Modify this as you would JAVA_ARGS but for non-service related subcommands
JAVA_ARGS_CLI="${JAVA_ARGS_CLI:-}"
# Modify this if you'd like TrapperKeeper specific arguments
TK_ARGS=""
# These normally shouldn't need to be edited if using OS packages
USER="puppet"
GROUP="puppet"
INSTALL_DIR="/opt/puppetlabs/server/apps/puppetserver"
CONFIG="/etc/puppetlabs/puppetserver/conf.d"
# Bootstrap path
BOOTSTRAP_CONFIG="/etc/puppetlabs/puppetserver/services.d/,/opt/puppetlabs/server/apps/puppetserver/config/services.d/"
# SERVICE_STOP_RETRIES can be set here to alter the default stop timeout in
# seconds.  For systemd, the shorter of this setting or 'TimeoutStopSec' in
# the systemd.service definition will effectively be the timeout which is used.
SERVICE_STOP_RETRIES=60
# START_TIMEOUT can be set here to alter the default startup timeout in
# seconds.  For systemd, the shorter of this setting or 'TimeoutStartSec'
# in the service's systemd.service configuration file will effectively be the
# timeout which is used.
START_TIMEOUT=300
# Maximum number of seconds that can expire for a service reload attempt before
# the result of the attempt is interpreted as a failure.
RELOAD_TIMEOUT=120
EOF

# =================================================================================================== #
# CERTIFICATES
# =================================================================================================== #

# LIST PENDING CERTIFICATES
sudo /opt/puppetlabs/bin/puppetserver ca list

# LIST ALL CERTIFICATES
# sudo /opt/puppetlabs/bin/puppetserver ca list --all

# SIGN A CERTIFICATE
# sudo /opt/puppetlabs/bin/puppetserver ca sign <name certificate>

# SIGN ALL PENDING CERTIFICATES
sudo /opt/puppetlabs/bin/puppetserver ca sign --all

# VERIFY COMMUNICATION
sudo /opt/puppetlabs/bin/puppet agent --test

# =================================================================================================== #
# MOTD CONFIGURATION
# =================================================================================================== #

# CREATING FILE STRUCTURE
sudo mkdir -p /etc/puppetlabs/code/environments/ITF/{manifests,modules/helloworld/manifests}
sudo touch /etc/puppetlabs/code/environments/ITF/manifests/site.pp
sudo touch /etc/puppetlabs/code/environments/ITF/modules/helloworld/manifests/{init.pp,motd.pp}

# DEFINES SITE.PP
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/manifests/site.pp
node default { }
node 'puppetclient' {
include helloworld 
include helloworld::motd
}
EOF

# DEFINES INIT.PP
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/modules/helloworld/manifests/init.pp
class helloworld {
    notify { 'hello, world!': }
 }
EOF

# DEFINES MOTD.PP
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/modules/helloworld/manifests/motd.pp
 class helloworld::motd {
    file { '/etc/motd':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode    => '0644',
    content => "Goodmorning, good afternoon, good evening, … CCS’er!\n",
    }
 }
EOF

# =================================================================================================== #
# CREATE FILE WITHOUT PRE-EXISTING MODULES
# =================================================================================================== #

# DEFINES SITE.PP
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/manifests/site.pp
node 'puppet_agent' {
file {'/tmp/hoera.txt':
ensure => present,  # test of de file aanwezig is!
mode => "0644", # permissions
content => "OKAYYYY It works… happy happy happy :-)!",
} 
}
EOF

# =================================================================================================== #
# INSTALL APACHE ON AGENT
# =================================================================================================== #

# INSTALL APACHE MODULE
sudo /opt/puppetlabs/bin/puppet module install --environment=ITF puppetlabs-apache
# ls -la /etc/puppetlabs/code/environments/ITF/modules

# CREATE INDEX.HTML
sudo mkdir -p /var/www/html

cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Site</title>
</head>
<body>
    <h1>Hello!</h1>
    <p>This website is managed by Puppet.</p>
</body>
</html>
EOF

# DEFINES SITE.PP
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/manifests/site.pp
node default { }
node 'puppetclient' {
  class { 'apache':
    default_vhost => false,
  }
  apache::vhost { 'example.com':
    port    => 80,
    docroot => '/var/www/html',
  }
  file { '/var/www/html':
    ensure => 'directory',
  }
  file { '/var/www/html/index.html':
    ensure  => present,
    mode    => '0644',
    content => file('/var/www/html/index.html'),
  }
}
EOF

# USE PUPPET PARSER TO VALIDATE SYNTAX ERRORS
sudo /opt/puppetlabs/bin/puppet parser validate /etc/puppetlabs/code/environments/ITF/manifests/site.pp

# =================================================================================================== #
# INSTALL DNS SERVER ON CLIENT
# =================================================================================================== #

# INSTALL MODULES
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --force --environment=ITF --version 5.0.0
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-concat --environment=ITF --version 7.0.0 --force
sudo /opt/puppetlabs/bin/puppet module install sourcedoctor-dns --environment=ITF --version 3.1.0

# DEFINES SITE.PP (RUN FIRST)
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/manifests/site.pp
node default { }
node 'puppetclient' {
  package { ['bind9', 'dnsutils']:
    ensure => installed,
  }
  service { 'bind9':
    ensure    => running,
    enable    => true,
    require   => Package['bind9'],
  }
}
EOF

# DEFINES SITE.PP (DELETE PREVIOUS, THEN RUN SECOND)
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/manifests/site.pp
node default { }
node 'puppetclient' {
  class { 'dns':
    forwarders => ['8.8.8.8', '8.8.4.4'],
    zone       => {
      'puppet.com' => {
        soa         => 'client.puppet.com',
        soa_email   => 'root.puppet.com',
        nameservers => ['client.puppet.com'],
      },
    },
  }
  dns::record::a {
    'client':
      zone => 'puppet.com',
      data => ['10.0.1.11'];
    'master':
      zone => 'puppet.com',
      data => ['10.0.1.10'];
  }
}
EOF

# USE PUPPET PARSER TO VALIDATE SYNTAX ERRORS
sudo /opt/puppetlabs/bin/puppet parser validate /etc/puppetlabs/code/environments/ITF/manifests/site.pp

# MANUALLY EDIT TO CORRECT DNSSEC (AVOID ERRORS)
cat <<EOF | sudo tee /etc/puppetlabs/code/environments/ITF/modules/dns/templates/named.conf.options.erb
<% if @dnssec_enable -%>
    //dnssec-enable yes;
    <% if @dnssec_validation != 'absent' -%>
    //dnssec-validation <%= @dnssec_validation %>;
    <%- end -%>
<%- else -%>
    //dnssec-enable no;
<%- end -%>
EOF