{
  imports = [
    ../hardware-configuration.nix
    ../modules/virtualization.nix
    ../modules/virtualbox-host.nix
    ../modules/virtualbox-guest.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
