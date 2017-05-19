#!/bin/bash

# Not used but need to start using
#apache_config_file="/etc/apache2/apache2.conf"
#apache_vhost_dir="/etc/apache2/sites-available/"
#mysql_config_file="/etc/mysql/my.cnf"
#php_config_file="/etc/php/7.0/apache2/php.ini"
#xdebug_config_file="/etc/php/7.0/mods-available/xdebug.ini"
#e107_web_root="/var/www/e107dev.box"



export DEBIAN_FRONTEND=noninteractive
apt-get update

# Apache
echo "****************** Provisioner: Installing apache ******************"

#export DEBIAN_FRONTEND=noninteractive

# Install Apache
apt-get install -y apache2 apache2-utils

a2enmod rewrite
a2enmod headers
a2dissite 000-default.conf

# Restart Apache
echo "****************** Provisioner: Restarting Apache ******************"

service apache2 restart

# echo "****************** Provisioner: Setup /var/www to point to /vagrant/www/e107 ******************"
# rm -rf /var/www
# ln -fs /vagrant/www/ /var/www

#if [ ! -h /var/www ]; 
#then 
#    mkdir /vagrant/www
#    rm -rf /var/www 
#    ln -s /vagrant/www /var/www
#    service apache2 restart
#fi

# Apache / Virtual Host Setup
echo "****************** Provisioner: Virtual Host Setup ******************"

cp /vagrant/e107dev.box.vhost /etc/apache2/sites-available/e107dev.box.conf

a2ensite e107dev.box.conf

# Restart Apache
echo "****************** Provisioner: Restarting Apache ******************"

service apache2 restart

# PHP
echo "****************** Provisioner: Installing PHP ******************"

#export DEBIAN_FRONTEND=noninteractive

# Install PHP and some modules
apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-gd php-curl php-xml php-mbstring php-pear libgd-tools libmcrypt-dev mcrypt


# MySQL

debconf-set-selections <<< "mysql-server mysql-server/root_password password pass"

debconf-set-selections <<< "mysql-server mysql-server/root_password_again password pass"

# Install MySQL
echo "****************** Provisioner: Installing MySQL ******************"

#export DEBIAN_FRONTEND=noninteractive

apt-get install -y mysql-server

# Configure MySQL Password Lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'pass' WITH GRANT OPTION;"

echo "****************** Provisioner: Restarting MySQl ******************"
service mysql restart



mysql --user="root" --password="pass" -e "CREATE USER 'e107'@'0.0.0.0' IDENTIFIED BY 'e107';"
mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'0.0.0.0' IDENTIFIED BY 'e107' WITH GRANT OPTION;"
mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'%' IDENTIFIED BY 'e107' WITH GRANT OPTION;"
mysql --user="root" --password="pass" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="pass" -e "CREATE DATABASE IF NOT EXISTS e107 DEFAULT CHARACTER SET = utf8 DEFAULT COLLATE = utf8_unicode_ci;"


echo "****************** Provisioner: Restarting MySQl ******************"
service mysql restart

# Add Timezone Support To MySQL

# mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=pass mysql



# Cleanup
echo "****************** Provisioner: Cleaning Up ******************"

#export DEBIAN_FRONTEND=noninteractive

apt-get -y autoremove

#export DEBIAN_FRONTEND=noninteractive

apt-get -y clean

# Restart Apache
echo "****************** Provisioner: Restarting Apache ******************"

service apache2 restart

# Install Git
echo "****************** Provisioner: Installing Git ******************"
apt-get install git -y > /dev/null


echo "Provisioner Finished "
