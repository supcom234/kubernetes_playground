# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "master" do |master|
    master.vm.box = "geerlingguy/centos7"
    master.vm.hostname = 'master'
    master.vm.box_check_update = false
	  master.vm.network "public_network"
	
    master.vm.network :private_network, ip: "192.168.50.10"
    master.vm.synced_folder ".", "/TFPlenum"
	  master.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
    end
  
    master.vm.provision "shell", path: "setup-master.sh"
  end

  config.vm.define "node1" do |node1|
    node1.vm.box = "geerlingguy/centos7"
    node1.vm.hostname = 'node1'
	  node1.vm.box_check_update = false
	  node1.vm.network "public_network"
	
    node1.vm.network :private_network, ip: "192.168.50.20"
	  node1.vm.synced_folder ".", "/TFPlenum"
	  node1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
    end
  
    node1.vm.provision "shell", path: "setup-node.sh"
  end
  
  config.vm.define "node2" do |node2|
    node2.vm.box = "geerlingguy/centos7"
    node2.vm.hostname = 'node2'
	  node2.vm.box_check_update = false
	  node2.vm.network "public_network"
	
    node2.vm.network :private_network, ip: "192.168.50.21"
	  node2.vm.synced_folder ".", "/TFPlenum"
	  node2.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
    end
  
    node2.vm.provision "shell", path: "setup-node.sh"
  end  

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
end
