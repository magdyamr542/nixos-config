{
  username = "amr";
  hostname = "amr";
  system = "x86_64-linux";
  nixosModule = ../nixos/hosts/linux.nix;
  homeModule = ../home/linux;
  homeDirectory = "/home/amr";
  stateVersion = "23.05";

  fullName = "amr";
  email = "magdyamr542@gmail.com";
  gitSettings = { };

  sshSettings = {
    "github.com" = {
      AddKeysToAgent = "yes";
      IdentityFile = "~/.ssh/github";
    };
    "ls14-scm.cs.tu-dortmund.de" = {
      AddKeysToAgent = "yes";
      IdentityFile = "~/.ssh/gitlab_tu_dortmund";
    };
    "*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

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
