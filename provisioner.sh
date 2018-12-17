#!/bin/bash

e107_home_vhost_conf="/etc/apache2/sites-available/0000-e107vagrant.home.conf"
e107dev_box_vhost_conf="/etc/apache2/sites-available/e107dev.box.conf"
e107old_box_vhost_conf="/etc/apache2/sites-available/e107.old.conf"
php_config_file="/etc/php/7.0/apache2/php.ini"
xdebug_config_file="/etc/php/7.0/mods-available/xdebug.ini"
# apache_config_file="/etc/apache2/apache2.conf"
# apache_vhost_dir="/etc/apache2/sites-available/"
# mysql_config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
web_logs_dir="/var/www/logs"
provision_log="/vagrant/logs/e107vagrantbox-provisioning.log"
# e107vagrant_home_document_root = "/var/www/home"


updatePackages () {
    echo "--> Provisioner: Running apt-get update..."
    apt-get update >> $provision_log 2>&1
}


# Installs Apache
installApache () {
    # Apache
    echo "--> Provisioner: Installing Apache..."
    # Install Apache
    apt-get install -y apache2 apache2-utils >> $provision_log 2>&1


    # Enable Modules
    echo "--> Provisioner: Enabling additional Apache modules..."
    a2enmod rewrite
    a2enmod headers


    # Disable default virtual host
    echo "--> Provisioner: Disabling Apache default virtual host..."
    a2dissite 000-default.conf
}

# PHP 5.6 Pre-install 
php56PreInstall () {
    echo "--> Provisioner: Preparing to install PHP 5.6 & Extensions..."
    apt install software-properties-common >> $provision_log 2>&1
    add-apt-repository ppa:ondrej/php >> $provision_log 2>&1
    apt-get update >> $provision_log 2>&1
}

# Installs PHP 5.6 & extensions
installPhp56 () {
    echo "--> Provisioner: Installing PHP 5.6 & Extensions..."
    # Install PHP 5.6 and some modules - no need of sudo
    apt-get install -y php5.6 php5.6-cli php5.6-mbstring \
    php5.6-mcrypt php5.6-mysql php5.6-xml php5.6-gd php5.6-curl \
    libgd-tools libmcrypt-dev mcrypt >> $provision_log 2>&1

}

# Installs PHP 7.0 & extensions
installPhp70 () {
    echo "--> Provisioner: Installing PHP & Modules..."

    # Install PHP and some extensions
    apt-get install -y php libapache2-mod-php php-mcrypt \
    php-mysql php-gd php-curl php-xml php-mbstring php-xdebug \
    php-pear libgd-tools libmcrypt-dev mcrypt >> $provision_log 2>&1
}

# Switches to PHP 5.6 both Apache and CLI
changeToPhp56 () {
    echo "--> Provisioner: Enabling PHP 5.6..."
    # apache module change
    a2dismod php7.0
    a2enmod php5.6
    service apache2 restart

    # cli change
    update-alternatives --set php /usr/bin/php5.6
}

# Restart Apache
restartApache () {
    echo "--> Provisioner: Restarting Apache..."
    service apache2 restart

}

# Make directory for 'Home' DocumentRoot
makeHomeDir () {
    # if [[ ! -d ${e107vagrant_home_document_root} ]]
    #     then
    #     mkdir -vp ${e107vagrant_home_document_root}
    # fi
    mkdir -vp /var/www/home
}

# Create Home/Dash Page
createHomePage () {
    echo "--> Provisioner: Creating home page..."
    homePage="<h1>Welcome Home!</h1><p>This is e107Vagrant Home!</p>"
    echo "$homePage" > "/var/www/home/index.html"
}

createHomeVhost () {
    # Apache / Virtual Host Setup
    echo "--> Provisioner: Setting up e107Vagrant Home page..."

    # Make the DocumentRoot for home page
    makeHomeDir

if [ ! -f "${e107_home_vhost_conf}" ]; then
        cat << EOF > ${e107_home_vhost_conf}
<VirtualHost *:80>

    # Admin email, Server Name (domain name) and any aliases
    ServerName  e107vagrant.home
    ServerAlias e107vagrant.box e107dev.box e107dev.home e107dev.test

    # Index file and Document Root (where the public files are located)
    DocumentRoot /var/www/home

    # Custom log file locations
    LogLevel warn
    ErrorLog ${web_logs_dir}/e107vagrant.home-apache-error.log
    CustomLog ${web_logs_dir}/e107vagrant.home-apache-access.log combined

    # Allow overrides in .htaccess file
    <Directory /var/www/home>
            Options FollowSymLinks
            AllowOverride All
    </Directory>

</VirtualHost>
EOF
echo "--> Provisioner: Created ${e107_home_vhost_conf} file..."
else
    echo "--> Provisioner: ${e107_home_vhost_conf} already present..."
fi

    # Enable e107vagrant.home
    echo "--> Provisioner: Enabling e107vagrant.home virtual host..."
    a2ensite 0000-e107vagrant.home.conf


    # Restart Apache
    restartApache

}


# Create e107dev.box VirtualHost
createMainDevBox () {
    # Apache VirtualHost Setup
    echo "--> Provisioner: Setting up VirtualHost e107dev.box..."

if [ ! -f "${e107dev_box_vhost_conf}" ]; then
        cat << EOF > ${e107dev_box_vhost_conf}
<VirtualHost *:80>

    # Admin email, Server Name (domain name) and any aliases
    ServerName  e107dev.box
    ServerAlias e107.v2 e107dev.v2 e107v2.test

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
    restartApache

}

# Create e107.old VHost
createOldBox () {
    # Apache VirtualHost Setup
    echo "--> Provisioner: Setting up VirtualHost e107.old..."

if [ ! -f "${e107old_box_vhost_conf}" ]; then
        cat << EOF > ${e107old_box_vhost_conf}
<VirtualHost *:80>

    # Admin email, Server Name (domain name) and any aliases
    ServerName  e107.old
    ServerAlias e107.legacy e107.v1 e107dev.v1

    # Index file and Document Root (where the public files are located)
    DocumentRoot /var/www/e107.old

    # Custom log file locations
    LogLevel warn
    ErrorLog ${web_logs_dir}/e107.old-apache-error.log
    CustomLog ${web_logs_dir}/e107.old-apache-access.log combined

    # Allow overrides in .htaccess file
    <Directory /var/www/e107.old>
            Options FollowSymLinks
            AllowOverride All
    </Directory>

</VirtualHost>
EOF
echo "--> Provisioner: Created ${e107old_box_vhost_conf} e107.old virtual host conf file..."
else
    echo "--> Provisioner: ${e107old_box_vhost_conf} already present..."
fi

    # Enable e107dev.box
    echo "--> Provisioner: Enabling e107.old virtual host..."
    a2ensite e107.old.conf

    # Restart Apache
    restartApache

}

# Edit xdebug.ini
editXdebugIni () {

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

}

# Update php.ini to display errors
modifyPhpIni () {
    echo "--> Provisioner: Editing php.ini to display errors..."
    sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
    sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}
}

# Setup MySQL
setUpMySql () {
    # MySQL

    debconf-set-selections <<< "mysql-server mysql-server/root_password password pass" >> $provision_log 2>&1

    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password pass" >> $provision_log 2>&1

    # Install MySQL
    echo "--> Provisioner: Installing MySQL..."
    apt-get install -y mysql-server >> $provision_log 2>&1



    # Configure MySQL Password Lifetime
    echo "--> Provisioner: Configuring MySQL password life-time..."
    echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf


    # Configure MySQL Remote Access
    echo "--> Provisioner: Configuring MySQL remote access..."
    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

    mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'pass' WITH GRANT OPTION;" >> $provision_log 2>&1

    echo "--> Provisioner: Restarting MySQL..."
    service mysql restart

    # Create mysql user named e107
    echo "--> Provisioner: Creating MySQL user named 'e107' with password: 'e107' ..."
    mysql --user="root" --password="pass" -e "CREATE USER 'e107'@'0.0.0.0' IDENTIFIED BY 'e107';" >> $provision_log 2>&1
    mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'0.0.0.0' IDENTIFIED BY 'e107' WITH GRANT OPTION;" >> $provision_log 2>&1
    mysql --user="root" --password="pass" -e "GRANT ALL ON *.* TO 'e107'@'%' IDENTIFIED BY 'e107' WITH GRANT OPTION;" >> $provision_log 2>&1
    mysql --user="root" --password="pass" -e "FLUSH PRIVILEGES;" >> $provision_log 2>&1

    # Create e107 database
    echo "--> Provisioner: Creating MySQL database named 'e107' ..."
    mysql --user="root" --password="pass" -e "CREATE DATABASE IF NOT EXISTS e107 DEFAULT CHARACTER SET = utf8 DEFAULT COLLATE = utf8_unicode_ci;" >> $provision_log 2>&1
}

# Installs Git
installGit () {
    echo "--> Provisioner: Installing Git..."
    #apt-get install git -y > /dev/null
    apt-get install git -y >> $provision_log 2>&1

}

# Restarts MySQL 
restartMySql () {
    echo "--> Provisioner: Restarting MySQL..."
    service mysql restart
}

# Cleans up post install
postInstallCleanup () {
    echo "--> Provisioner: Cleaning Up..."
    apt-get -y autoremove >> $provision_log 2>&1
    apt-get -y clean >> $provision_log 2>&1
}

# ---------------------------------------- START ROUTINE -----------------------------
# Switch to  Non-Interactive mode
export DEBIAN_FRONTEND=noninteractive


# Update all packages before installing anything
updatePackages


# Install Apache
installApache


# Restart Apache
restartApache

# create Home VirtualHost
createHomeVhost && createHomePage


# Main Dev Apache VirtualHost Setup
createMainDevBox

# e107.old Dev Box
createOldBox

# PHP
installPhp70

# Install PHP5.6 & Change to that
php56PreInstall && installPhp56 && changeToPhp56

# Modify php.ini
modifyPhpIni

# Edit xdebug.ini
editXdebugIni


# MySQL
setUpMySql

# Restart MySQL
restartMySql


# Add Timezone Support To MySQL
# mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=pass mysql

# Install Git
installGit

# Cleanup
postInstallCleanup

# Restart Apache
restartApache

echo "*** Provisioner DONE Provisioning! ***"

