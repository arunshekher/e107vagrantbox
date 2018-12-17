# -*- mode: ruby -*-
# vi: set ft=ruby :

if ! ENV['EVB_SKIP_LOGO'] then
	puts "\033[38;5;33m       _______  _____  "
	puts "  ___ <  / __ \\/__  /  "
	puts " / _ \\/ / / / /  / /   " 
	puts "/  __/ / /_/ /  / /    "
	puts "\\___/_/\\____/  /_/     \033[0m"
	puts "\033[38;5;196m _    __                             __  ____              "
	puts "| |  / /___ _____ __________ _____  / /_/ __ )____  _  __  "
	puts "| | / / __ `/ __ `/ ___/ __ `/ __ \\/ __/ __  / __ \\| |/_/  "
	puts "| |/ / /_/ / /_/ / /  / /_/ / / / / /_/ /_/ / /_/ />  <    "
	puts "|___/\\__,_/\\__, /_/   \\__,_/_/ /_/\\__/_____/\\____/_/|_|    "
	puts "          /____/                                                "
	puts "\033[0m"
end

require 'yaml'

e107VbYaml = File.expand_path("./e107.yaml")
settings = YAML::load(File.read(e107VbYaml))
ipAddress = settings["ip"] ||= "10.0.0.7"

Vagrant.configure "2" do |config|
  config.vm.box = "ubuntu/xenial64"
  #config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64/versions/20170516.0.0/providers/virtualbox.box"
  config.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  config.vm.define "e107vagrantbox" do |e107vagrantbox|
  end

    # Configure few of VirtualBox Settings via yaml
    config.vm.provider "virtualbox" do |vb|
      vb.name = "e107vagrantbox"
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "1024"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      # vb.customize ["modifyvm", :id, "--ostype", "Debian_64"]
      # vb.customize ["modifyvm", :id, "--audio", "none", "--usb", "off", "--usbehci", "off"]
    end

  # virtual machine image name ?
  config.vm.hostname = "ubuntu-xenial64-e107vagrant.box"

  # Configure A Private Network IP
  config.vm.network :private_network, ip: settings["ip"] ||= "10.0.0.7"
  # config.vm.network :private_network, {
  #   ip: "10.0.0.7"
  # }

  config.vm.boot_timeout = 500

  config.vm.synced_folder "./www/e107dev.box", "/var/www/e107dev.box", create: true, group: "www-data", owner: "www-data"
  config.vm.synced_folder "./www/e107.old", "/var/www/e107.old", create: true, group: "www-data", owner: "www-data"
  config.vm.synced_folder "./www/home", "/var/www/home", create: true, group: "www-data", owner: "www-data"
  config.vm.synced_folder "./logs", "/var/www/logs", create: true, group: "www-data", owner: "www-data"


  # config.vm.provision "file", source: "./files/home.php", destination: "/var/www/home/home.php"

  
  # Add the tty fix as mentioned in issue 1673 on vagrant repo
  # To avoid 'stdin is not a tty' messages
  # vagrant provisioning in shell runs bash -l
  config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision :shell, :path => "provisioner.sh"


  # Service startups (always run)
  config.vm.provision :shell, {
    path: "initializer.sh",
    name: "initializer",
    run: "always"
  }

  #test yaml file - this is tested to work, need to put it into proper use if need be
  # if File.exists? "./installphp.sh" then
  #     phpVersion = settings["php"] ||= "5.6"
  #   config.vm.provision "shell", path: "./installphp.sh", args: [phpVersion]
  # end


  config.vm.post_up_message = <<-MESSAGE
       __  ___                    __       
 _ /| /  \\   /\\  /_  _  _ _  _ |_|__) _    
(-  | \\__/  /  \\/(_|(_)| (_|| )|_|__)(_))( 
                    _/                     

All done!

    You can now visit the IP #{ipAddress} in your browser to go to the homepage!
    
    Complete e107 installation process by going to http://e107dev.box after -
    setting up the hostname 'e107dev.box' in your hosts file. 
    
    The following commands are handy. Type in your terminal:
      * 'vagrant ssh' - to ssh to this virtual machine
      * 'vagrant halt' - to shutdown this virtual machine
      * 'vagrant reload' - to restart this virtual machine
      * 'vagrant destroy' - to destroy the virtual machine
      * 'vagrant -h' - for help
    
    More Vagrant commands documentation:
        https://www.vagrantup.com/docs/cli/
    
    
    After loging into virtual machine can run the following commands:
      
      To see and follow apache error logs for site e107dev.box run:
          'sudo tailf /var/www/logs/e107dev.box-apache-error.log'
      
      To query status (or other http endpoint commands) run:
          vagrant ssh <NODE> -c 'curl http://localhost:39132/info'
      
      To access a ledger database run:
          vagrant ssh <NODE> -c 'sudo -iustellar psql'
  MESSAGE



end
