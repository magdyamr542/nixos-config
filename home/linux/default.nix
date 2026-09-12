{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./packages.nix
    ./shell.nix
  ];

  home.file = {
    ".proot/project-root.sh".source = ../../dotfiles/zsh/project-root.sh;
    ".ssh" = {
      recursive = true;
      source = ../../dotfiles/ssh;
    };
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = config.home.sessionVariables.VISUAL;
    SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";

    FZF_DEFAULT_COMMAND = "fd --type file --follow --hidden --exclude .git";
    FZF_CTRL_T_COMMAND = "fd --type file --follow --hidden --exclude .git";

    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=245";
    DISABLE_MAGIC_FUNCTIONS = "true";

    AWS_PAGER = "";
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  nix.gc = {
    automatic = true;
    dates = [ "monthly" ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
