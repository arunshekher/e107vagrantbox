# e107 VagrantBox
 An elementary vagrant box configuration arranged for e107 development.

# Software included
e107 VagrantBox is built on Ubuntu 16.04.2 LTS (Xenial)64-bit base vagrant box. The server is provisioned with following versions Apache, MySQL and PHP

    Apache 2.4.18
    MySQL 5.7.18
    PHP 7.0.15

## Credentials  
    Vagrant Box IP Address: 10.0.0.7
    Virtual Host ServerName: e107dev.box
    MySQL User: e107
    MySQL Password: e107
    MySQL Database: e107


### Additional Provisioning and Initializations
* Creates a virtual host and points to the virtual host ServerName e107dev.box (require modifying host machine's hosts file for it to work) 
* Clones the current state of e107 Github Repository to to virtual host's document root.
* Creates mysql user and database for e107 installation

# Dependencies
e107 VagrantBox requires recent versions of Vagrant and VirtualBox installed. Find the latest versions for your operating system at these links.

https://www.vagrantup.com/downloads.html  
https://www.virtualbox.org/wiki/Downloads  


