Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_version = "24.05"
  config.vm.hostname = "nixbox"

  config.vm.allow_fstab_modification = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.disksize.size = '80GB'


  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.cpus = 4
    virtualbox.memory = 8192
    # The box ships with vboxvga; VirtualBox recommends vmsvga for modern guests.
    virtualbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
  end

  # vagrant-disksize only resizes the VirtualBox disk image to 80GB; it
  # never touches the guest's partition table or filesystem. Grow both here,
  # before anything runs nixos-rebuild, because the box's stock ~10GB
  # partition has no room for a full system-closure build. NixOS's own
  # boot.growPartition/fileSystems.autoResize (see hardware-nixbox.nix)
  # can't help with this first build: they only take effect from the initrd
  # of a generation that already has them enabled, and that generation
  # doesn't exist until the first switch succeeds.
  config.vm.provision "shell", inline: <<-SHELL
    sudo nix-shell -p cloud-utils e2fsprogs --run '
      set -e
      growpart /dev/sda 1 || true
      resize2fs /dev/sda1
    '
  SHELL

  # Upgrade NixOS from 24.05 to 26.05 on first boot
  config.vm.provision "shell", inline: <<-SHELL
    # Check current NixOS version
    current_version=$(nixos-version | cut -d'.' -f1,2)

    if [ "$current_version" != "26.05" ]; then
      echo "Upgrading NixOS from $current_version to 26.05..."

      # Update to 26.05 channel
      sudo nix-channel --add https://nixos.org/channels/nixos-26.05 nixos
      sudo nix-channel --update

      # Rebuild with new channel
      sudo nixos-rebuild switch --upgrade

      echo "NixOS upgraded to 26.05. Please run 'vagrant reload' to complete the upgrade."
    else
      echo "Already running NixOS 26.05"
    fi
  SHELL
end
