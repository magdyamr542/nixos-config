{
  username = "vagrant";
  hostname = "nixbox";
  system = "x86_64-linux";
  nixosModule = ../nixos/hosts/nixbox.nix;

  fullName = "Vagrant User";
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
  ];
  passwordHashFile = null;
  # Vagrant owns ~/.ssh/authorized_keys and may replace its insecure default key.
  authorizedKeys = [ ];
}
