{
  config,
  pkgs,
  ...
}:
{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # git
      gcm = "git commit -m";
      gsh = "git show";
      gpl = "git pull";

      #nix
      nix-shell = "nix-shell --run zsh";
      deletegarbage = "sudo nix-collect-garbage --delete-old";

      # general
      ll = "ls -l";
      iptv = "iptvnator";
      tm = "ssh-tunnel-manager";
      br = "browser-tab-groups";
      t = "tree";
      open = "xdg-open";
      o = "xdg-open";

      # keyboard layout
      en = "setxkbmap us";
      de = "setxkbmap de";
      ar = "setxkbmap ara";

      # Open camera
      camera = "ffplay /dev/video0";

      # Screen recording
      screenrecord = "obs";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "autojump"
        "colored-man-pages"
        "history-substring-search"
        "kubectl"
        "aws"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    history = {
      size = 10000;
      extended = true;
      path = "${config.xdg.dataHome}/.zsh_history";
    };

    initContent = ''
      source $HOME/.p10k.zsh
      source $HOME/.proot/project-root.sh
      bindkey jj vi-cmd-mode
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

}
