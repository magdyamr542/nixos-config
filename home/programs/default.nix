{ host, ... }:

{
  imports = [
    ./neovim.nix
    ./vscode
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = host.sshSettings;
  };
}
