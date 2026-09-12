{ host, lib, ... }:

{
  imports = [ ./neovim.nix ] ++ lib.optionals (lib.hasSuffix "-linux" host.system) [ ./vscode ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = host.sshSettings;
  };
}
