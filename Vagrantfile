# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.define :php do |php|
		php.vm.box = "hashicorp/precise32"
        php.vm.provision :shell, path: "provision/php.sh"
		php.vm.network "private_network", ip: "192.168.50.2"
  end

  config.vm.define :mysql do |mysql|
		mysql.vm.box = "hashicorp/precise32"
        mysql.vm.provision :shell, path: "provision/mysql.sh"
		mysql.vm.network "private_network", ip: "192.168.50.3"
  end

  config.vm.define :vault do |vault|
		vault.vm.box = "hashicorp/precise32"
        vault.vm.provision :shell, path: "provision/vault.sh"
		vault.vm.network "private_network", ip: "192.168.50.4"
  end

end
