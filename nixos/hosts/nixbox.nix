{
  imports = [
    ../hardware-nixbox.nix
    ../modules/virtualization.nix
    ../modules/virtualbox-guest.nix
  ];

  # nixbox uses a BIOS disk and installs GRUB to its virtual drive.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # The nixbox image intentionally skips this boot-time filesystem check.
  boot.initrd.checkJournalingFS = false;

  # Keep provisioning convenient in the disposable test machine.
  security.sudo.wheelNeedsPassword = false;
}
