{
  username = "vagrant";
  hostname = "nixbox";
  system = "x86_64-linux";
  nixosModule = ../nixos/hosts/nixbox.nix;

  fullName = "Vagrant User";
  email = "magdyamr542@gmail.com";

  extraGroups = [
    "wheel"
    "docker"
    "networkmanager"
    "audio"
  ];
  passwordHashFile = null;
  # Vagrant owns ~/.ssh/authorized_keys and may replace its insecure default key.
  authorizedKeys = [ ];
}
