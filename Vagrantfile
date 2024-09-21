# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_version = "23.11"

  config.ssh.username = "amr"
  config.ssh.private_key_path = "./key"

  config.vm.disk :disk, size: "100GB", primary: true
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "6144"
    vb.cpus = "3"
  end

end
