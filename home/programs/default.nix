{
  imports = [
    ./neovim.nix
    ./vscode
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      github = {
        host = "github.com";
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/github";
      };
      gitlab-tu-dortmund = {
        host = "ls14-scm.cs.tu-dortmund.de";
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/gitlab_tu_dortmund";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
