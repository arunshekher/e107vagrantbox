# e107 VagrantBox
 An elementary vagrant box configured for e107 development.

 ![e107vagrantbox-up-win](https://cloud.githubusercontent.com/assets/315195/26256529/568c8d00-3cce-11e7-8dc2-00db91cf7710.png)

 ![e107vagrantbox-up-linux](https://cloud.githubusercontent.com/assets/315195/26246956/bf1c53c2-3cac-11e7-9714-0443166d07f4.png)


 ![screen shot 2017-05-19 at 12 11 24 pm](https://cloud.githubusercontent.com/assets/315195/26240873/a6a01c02-3c93-11e7-9723-9832e1e76539.png)


# Software included
e107-VagrantBox is built on Ubuntu 16.04.2 LTS (Xenial)64-bit base vagrant box. The server is provisioned with following versions of web stack software, modules and tools.

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

# Usage  

```sh
# terminal

git clone https://github.com/arunshekher/e107vagrantbox.git e107vagrantbox  

cd e107vagrantbox/  

vagrant up  
```  
   
## Credentials  
* Machine IP Address: _10.0.0.7_
* Virtual Host ServerName: _e107dev.box_
* MySQL User: _e107_
* MySQL Password: _e107_
* MySQL Database: _e107_

### Point Browser to 10.0.0.7 

![image](https://cloud.githubusercontent.com/assets/315195/26256882/86519f0c-3ccf-11e7-97c5-847afa67da77.png)  

Point your browser to e107dev.box if you have set up that server name to point to the IP 10.0.0.7  in your hosts file.

#### MySQL Remote Access

![image](https://cloud.githubusercontent.com/assets/315195/26253409/51ecb7ac-3cc4-11e7-870e-894128b1b631.png)

   
### Additional Provisioning and Initialization
* Creates a virtual host with the ServerName `e107dev.box` (modify host machine's hosts file to map ServerName to vagrant box's ip: 10.0.0.7 ) 
* Clones the current state of e107 Github Repository to to virtual host's document root.

# Dependencies
e107-VagrantBox requires recent versions of Vagrant and VirtualBox installed. Find the latest versions for your operating system at these links.

https://www.vagrantup.com/downloads.html  
https://www.virtualbox.org/wiki/Downloads  


