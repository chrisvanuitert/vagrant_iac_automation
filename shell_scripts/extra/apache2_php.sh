# UPDATE THE PACKAGE LIST AND INSTALL THE APACHE2 WEB SERVER
sudo apt install -y apache2

# INSTALL PHP AND THE APACHE PHP MODULE
sudo apt install php libapache2-mod-php -y

# MOVE TO THE DIRECTORY CONTAINING AVAILABLE APACHE MODULES
cd /etc/apache2/mods-available

# ENABLE THE SERVER INFORMATION MODULE
sudo a2enmod info.load

# WEBSITE FILE
# /var/www/php/index.php

# PORT CONFIGURATION
# /etc/apache2/ports.conf

# SITE CONFIGURATION
# /etc/apache2/sites-available/phpsite.conf

# DEFAULT TEMPLATE
# /etc/apache2/sites-available/000-default.conf

# ACTIVATE THE NEW PHP WEBSITE CONFIGURATION
sudo a2ensite phpsite.conf

# ENSURE APACHE STARTS AUTOMATICALLY ON SYSTEM BOOT
sudo systemctl enable apache2

# RESTART THE APACHE SERVICE TO APPLY ALL NEW SETTINGS
sudo systemctl restart apache2