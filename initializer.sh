#!/bin/bash

provision_log="/vagrant/logs/e107vagrantbox-provisioning.log"

clone107 () {
	echo "--> Initilizer: Cloning e107 from Github Repo..."
	git clone https://github.com/e107inc/e107.git /vagrant/www/e107dev.box >> $provision_log 2>&1
}

pulle107 () {
	echo "--> Initilizer: Pulling e107 from Github Repo..."
	cd /vagrant/www/e107dev.box && git pull origin master >> $provision_log 2>&1
}

# Check internet access using basic ping result to Google's primary DNS servers 
ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
	ping_result="$(ping -c 2 4.2.2.2 2>&1)"
fi


if [[ $ping_result == *bytes?from* ]]; then

	if [ ! -f /vagrant/www/e107dev.box/e107_config.php ];
	then
		clone107
	else
		pulle107
	fi
else
	echo "No internet access available. Skipping e107 package fetching/updation from Github..."
fi






echo "*** Initilizer: Finished! ***"