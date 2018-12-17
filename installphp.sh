#!/bin/bash

currentVersion=""
phpVersion=$1

checkCurrentVersion () {
	# The current PHP Version of the machine
    PHPVersion=$(php -v|grep --only-matching --perl-regexp "5\.\\d+\.\\d+");
    # Truncate the string abit so we can do a binary comparison
	currentVersion=${PHPVersion::0-2};
}

changePhp () {
    echo "--> Provisioner: Enabling PHP $1 ..."


   	# apache module change
    a2dismod php"${2}"
    a2enmod php"${1}"
    service apache2 restart

    # cli change
    update-alternatives --set php /usr/bin/php"${1}"
}

changePhp "$phpVersion" "$currentVersion"




echo "##### $1 #####"

echo "------- $phpVersion ---------"