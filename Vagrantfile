# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu1404-opsworks"

  config.vm.define "app" do |layer|
    layer.vm.provision "opsworks", type:"shell", args:[
      'opsworks.json'
    ]

    # Forward port 80 so we can see our work
    layer.vm.network "forwarded_port", guest: 80, host: 5000
    layer.vm.network "private_network", ip: "10.10.10.10"
  end
end
