{ host, ... }:

{
  imports = [
    ./packages.nix
    ./gui-apps.nix
    ./shell.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    AWS_PAGER = "";
    CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE = "1";
    RIPGREP_CONFIG_PATH = "${host.homeDirectory}/.config/ripgrep/ripgreprc";
  };

  xdg.configFile."ripgrep/ripgreprc".source = ../../dotfiles/ripgrep/ripgreprc;
}
