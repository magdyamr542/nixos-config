{
  username = "amr";
  hostname = "amr";
  system = "x86_64-linux";
  nixosModule = ../nixos/hosts/linux.nix;

  fullName = "amr";
  email = "magdyamr542@gmail.com";

  extraGroups = [
    "wheel"
    "docker"
    "networkmanager"
    "audio"
    "vboxusers"
  ];
  passwordHashFile = "/etc/nixos/secrets/amr-password-hash";
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOT+/Bl0QBOJCJZG+EoZENziljwEg74RbZXw8bjWgIlk magdyamr542@gmail.com"
  ];
}
