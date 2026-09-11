{
  inputs,
  lib,
  config,
  host,
  pkgs,
  ...
}:
{
  imports = [
    # You can also split up your configuration and import pieces of it here:
    ./desktop.nix
    ./git.nix
    ./packages.nix
    ./shell.nix
    ./tmux.nix
    ./programs
  ];

  home = {
    username = host.username;
    homeDirectory = "/home/${host.username}";
  };

  # Dotfiles
  home.file = {
    ".p10k.zsh".source = ../dotfiles/zsh/p10k.zsh;

    # project root
    ".proot/project-root.sh".source = ../dotfiles/zsh/project-root.sh;

    # ssh
    ".ssh" = {
      recursive = true;
      source = ../dotfiles/ssh;
    };

  };

  # Extend path
  home.sessionPath = [
  ];

  # Programs
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";

    FZF_DEFAULT_COMMAND = "fd --type file --follow --hidden --exclude .git";
    FZF_CTRL_T_COMMAND = "fd --type file --follow --hidden --exclude .git";

    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=245";
    DISABLE_MAGIC_FUNCTIONS = "true";

    AWS_PAGER = "";

    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = [ "monthly" ];
  };

  news.display = "silent";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
}
