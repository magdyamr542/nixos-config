{
  imports = [
    ./neovim.nix
    ./vscode
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
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
  };
}
