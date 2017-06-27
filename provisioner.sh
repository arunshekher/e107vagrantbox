#!/bin/bash

e107dev_box_vhost_conf="/etc/apache2/sites-available/e107dev.box.conf"
php_config_file="/etc/php/7.0/apache2/php.ini"
xdebug_config_file="/etc/php/7.0/mods-available/xdebug.ini"
# apache_config_file="/etc/apache2/apache2.conf"
# apache_vhost_dir="/etc/apache2/sites-available/"
# mysql_config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
web_logs_dir="/var/www/logs"


# Switch to  Non-Interactive mode
export DEBIAN_FRONTEND=noninteractive


# Update all packages before installing anything
echo "--> Provisioner: Running apt-get update..."
apt-get update >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1


# Apache
echo "--> Provisioner: Installing Apache..."
# Install Apache
apt-get install -y apache2 apache2-utils >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1


# Enable Modules
echo "--> Provisioner: Enabling additional Apache modules..."
a2enmod rewrite
a2enmod headers


# Disable default virtual host
echo "--> Provisioner: Disabling Apache default virtual host..."
a2dissite 000-default.conf


# Restart Apache
echo "--> Provisioner: Restarting Apache..."
service apache2 restart


# Apache / Virtual Host Setup
echo "--> Provisioner: Setting up virtual host e107dev.box..."

if [ ! -f "${e107dev_box_vhost_conf}" ]; then
		cat << EOF > ${e107dev_box_vhost_conf}
<VirtualHost *:80>

    # Admin email, Server Name (domain name) and any aliases
    ServerName  e107dev.box
    ServerAlias www.e107dev.box

    # Index file and Document Root (where the public files are located)
    DocumentRoot /var/www/e107dev.box

    # Custom log file locations
    LogLevel warn
    ErrorLog ${web_logs_dir}/e107dev.box-apache-error.log
    CustomLog ${web_logs_dir}/e107dev.box-apache-access.log combined

    # Allow overrides in .htaccess file
    <Directory /var/www/e107dev.box>
            Options FollowSymLinks
            AllowOverride All
    </Directory>

</VirtualHost>
EOF
echo "--> Provisioner: Created e107dev.box virtual host conf file..."
else
    echo "--> Provisioner: /etc/apache2/sites-available/e107dev.box.conf already present..."
fi

# Enable e107dev.box
echo "--> Provisioner: Enabling e107dev.box virtual host..."
a2ensite e107dev.box.conf


# Restart Apache
echo "--> Provisioner: Restarting Apache..."
service apache2 restart


# PHP
echo "--> Provisioner: Installing PHP & Modules..."

# Install PHP and some modules
apt-get install -y php libapache2-mod-php php-mcrypt \
php-mysql php-gd php-curl php-xml php-mbstring php-xdebug \
php-pear libgd-tools libmcrypt-dev mcrypt >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1

# Modify php.ini
echo "--> Provisioner: Editing php.ini to display errors..."
sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}

# Edit xdebug.ini
echo "--> Provisioner: Editing xdebug.ini for remote debugging..."
if [ ! -f "{$xdebug_config_file}" ]; then
        cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.0.7
xdebug.remote_log=${web_logs_dir}/xdebug.log
EOF
fi


# MySQL

debconf-set-selections <<< "mysql-server mysql-server/root_password password pass"

debconf-set-selections <<< "mysql-server mysql-server/root_password_again password pass"

# Install MySQL
echo "--> Provisioner: Installing MySQL..."
apt-get install -y mysql-server >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1



# Configure MySQL Password Lifetime
echo "--> Provisioner: Configuring MySQL password life-time..."
echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf


# Configure MySQL Remote Access
echo "--> Provisioner: Configuring MySQL remote access..."
sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'pass' WITH GRANT OPTION;"

echo "--> Provisioner: Restarting MySQL..."
service mysql restart

# Create e107 user 
echo "--> Provisioner: Creating MySQL 'e107' user with password: 'e107' ..."
mysql --user="root" --password="pass" -e "CREATE USER 'e107'@'0.0.0.0' IDENTIFIED BY 'e107';"
mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'0.0.0.0' IDENTIFIED BY 'e107' WITH GRANT OPTION;"
mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'%' IDENTIFIED BY 'e107' WITH GRANT OPTION;"
mysql --user="root" --password="pass" -e "FLUSH PRIVILEGES;"

# Create e107 database
echo "--> Provisioner: Creating MySQL database named 'e107' ..."
mysql --user="root" --password="pass" -e "CREATE DATABASE IF NOT EXISTS e107 DEFAULT CHARACTER SET = utf8 DEFAULT COLLATE = utf8_unicode_ci;"


echo "--> Provisioner: Restarting MySQL..."
service mysql restart

# Add Timezone Support To MySQL

# mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=pass mysql

# Install Git
echo "--> Provisioner: Installing Git..."
#apt-get install git -y > /dev/null
apt-get install git -y >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1


# Cleanup
echo "--> Provisioner: Cleaning Up..."

apt-get -y autoremove >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1

apt-get -y clean >> /vagrant/logs/e107vagrantbox-provisioning.log 2>&1

# Restart Apache
echo "--> Provisioner: Restarting Apache..."

service apache2 restart



echo "*** Provisioner DONE Provisioning! ***"
