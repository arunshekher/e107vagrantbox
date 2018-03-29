# e107VagrantBox

[![Join the chat at https://gitter.im/e107vagrantbox/Lobby](https://badges.gitter.im/e107vagrantbox/Lobby.svg)](https://gitter.im/e107vagrantbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
 An elementary vagrant box configured for e107 development.

 ![e107vagrantbox-up-win](https://cloud.githubusercontent.com/assets/315195/26256529/568c8d00-3cce-11e7-8dc2-00db91cf7710.png)

 ![e107vagrantbox-up-linux](https://cloud.githubusercontent.com/assets/315195/26246956/bf1c53c2-3cac-11e7-9714-0443166d07f4.png)


 ![screen shot 2017-05-19 at 12 11 24 pm](https://cloud.githubusercontent.com/assets/315195/26240873/a6a01c02-3c93-11e7-9723-9832e1e76539.png)


# What's Provisioned?
e107VagrantBox is built on Ubuntu 16.04.2 LTS (Xenial)64-bit base vagrant box. The server is provisioned with following versions of web stack software, modules and tools. More added regularly.

    Apache 2.4.18
    MySQL 5.7.18
    PHP 7.0.15
    Xdebug v2.4.0
    
    
    PHP Modules:
       php-mcrypt 
       php-gd 
       php-curl 
       php-xml 
       php-mbstring
       php-xdebug

    Git 2.7.4

    e107 (Current Dev. Version)

# Installation
e107VagrantBox requires recent versions of Vagrant and VirtualBox installed. Find the latest versions for your operating system at these links.

[Vagrant Downlod](https://www.vagrantup.com/downloads.html)  
[VirtualBox Download](https://www.virtualbox.org/wiki/Downloads)  

# Usage
Assuming that you have successfully installed the current versions of VirtualBox and Vagrant. Clone this repository to a location of your choice in your file system and run the command 'vagrant up' within the cloned directory.

```sh
$ git clone https://github.com/arunshekher/e107vagrantbox.git

$ cd e107vagrantbox/  

$ vagrant up  
```  
   
## Credentials
You'll need them in the next step:   
+ Machine IP Address: `10.0.0.7`
+ Virtual Host ServerName: `e107dev.box`
+ MySQL User: `e107`
+ MySQL Password: `e107`
+ MySQL Database: `e107`
+ MySQL Host:
    + Local: `localhost`
    + Remote: `10.0.0.7`
     
    
+ MySQL root user: `root`
+ MySQL root user: `pass`

### Point Browser to 10.0.0.7 
Begin e107 installation process by pointing your browser to the above given machine IP address. Use the credentials provided above to finish off e107 installation. Start developing something awesome for e107!

![image](https://cloud.githubusercontent.com/assets/315195/26256882/86519f0c-3ccf-11e7-97c5-847afa67da77.png)  

Point your browser to e107dev.box if you have set up that server name to point to the IP 10.0.0.7  in your hosts file.

#### MySQL Remote Access

![image](https://cloud.githubusercontent.com/assets/315195/26253409/51ecb7ac-3cc4-11e7-870e-894128b1b631.png)

   
### Additional - Optional Setup
* Modify host machine's hosts file to map ServerName `e107dev.box` to vagrant box's ip: 10.0.0.7




