#!/bin/bash

clone107 () {
	echo "****************** Initilizer: Cloning e107 from Githu Repo ******************"
	git clone https://github.com/e107inc/e107.git /vagrant/www/e107dev.box
}

pulle107 () {
	echo "****************** Initilizer: Pulling e107 from Githu Repo ******************"
	cd /vagrant/www/e107dev.box && git pull origin master
}

# echo "****************** Initilizer: Cloning e107 from Githu Repo ******************"

# git clone https://github.com/e107inc/e107.git /var/www/e107dev.box




#if [ ! -f /vagrant/www/e107dev.box/e107_config.php ];
#	then
#		git clone https://github.com/e107inc/e107.git /vagrant/www/e107dev.box
#	else
#		cd /vagrant/www/e107dev.box && git pull origin master
#fi


if [ ! -f /vagrant/www/e107dev.box/e107_config.php ];
	then
		clone107
	else
		pulle107
fi


echo "****************** Initilizer: DONE ******************"