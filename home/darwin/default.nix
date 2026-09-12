{ host, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./gui-apps.nix
    ./shell.nix
    ./programs.nix
    ../tmux.nix
    ../programs/neovim.nix
  ];

  home = {
    username = host.username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
      AWS_PAGER = "";
      CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE = "1";
      RIPGREP_CONFIG_PATH = "/Users/${host.username}/.config/ripgrep/ripgreprc";
    };
  };

  home.file.".p10k.zsh".source = ../../dotfiles/zsh/p10k.zsh;

  xdg.configFile."ripgrep/ripgreprc".source = ../../dotfiles/ripgrep/ripgreprc;

  programs.home-manager.enable = true;
}
