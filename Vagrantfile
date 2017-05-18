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

Vagrant.configure "2" do |config|
  config.vm.box = "ubuntu/xenial64"
  #config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64/versions/20170516.0.0/providers/virtualbox.box"
  config.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  config.vm.define "e107vagrantbox" do |e107vagrantbox|
  end

  
config.vm.provider "virtualbox" do |vb|
  	vb.name = "e107vagrantbox"
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.hostname = "ubuntu-xenial64-e107vagrant.box"
  config.vm.network :private_network, {
    ip: "10.0.0.7"
  }


  config.vm.synced_folder "./www/e107dev.box", "/var/www/e107dev.box", create: true, group: "www-data", owner: "www-data"

  


  config.vm.provision :shell, :path => "provisioner.sh"


  # Service startups (always run)
  config.vm.provision :shell, {
    path: "initializer.sh",
    name: "services",
    run: "always"
  }

end
