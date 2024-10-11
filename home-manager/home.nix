{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./packages.nix
    ./zsh.nix
    ./neovim.nix
    ./vscode/vscode.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "amr";
    homeDirectory = "/home/amr";
  };

  # Dotfiles
  home.file = {
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".gitconfig".source = ./dotfiles/.gitconfig;
    ".alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
    ".alacritty/solarized_dark.toml".source = ./dotfiles/solarized_dark.toml;

    # tmux
    ".config/tmux/tmux.conf".source = ./dotfiles/.tmux.conf;
    ".config/tmux/tmux.conf.local".source = ./dotfiles/.tmux.conf.local;

    # project root
    ".proot/project-root.sh".source = ./custom-programs/project-root.sh;

    # ssh
    ".ssh" = {
      recursive = true;
      source = ./users/amr/ssh_keys;
    };

    # i3
    ".wallpaper.png".source = ./static/wallpaper.png;
    ".config/i3/config".source = ./dotfiles/i3_config;
    ".config/rofi/config.rasi".source = ./static/rofi/config.rasi;
    ".config/rofi/dracula.rasi".source = ./static/rofi/dracula.rasi;
    ".config/rofi/nord.rasi".source = ./static/rofi/nord.rasi;
    ".scripts/i3/screenshot.sh".source = ./static/scripts/i3/screenshot.sh;
    ".scripts/i3/update-brithness.sh".source = ./static/scripts/i3/update-brithness.sh;
    ".scripts/i3/update-volume.sh".source = ./static/scripts/i3/update-volume.sh;
  };

  # Programs
  programs.home-manager.enable = true;
  programs.git.enable = true;

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
  };

  # Notification system
  services.dunst = {
    enable = true;
    settings = {
      urgency_low = {
        background = "#1d1f21";
        foreground = "#4da1af";
        frame_color = "#4da1af";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1d1f21";
        foreground = "#70a040";
        frame_color = "#70a040";
        timeout = 15;
      };

      urgency_critical = {
        background = "#1d1f21";
        foreground = "#dd5633";
        frame_color = "#dd5633";
        timeout = 0;
      };

      shortcuts = {
        context = "mod4+grave";
        close = "mod4+shift+space";
      };
    };
  };

  # Font
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "MesloLGM Nerd Font Mono" ];
      sansSerif = [ "MesloLGM Nerd Font Mono" ];
      monospace = [ "MesloLGM Nerd Font Mono" ];
    };
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };

  # SSH
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      github = {
        host = "github.com";
        identityFile = "~/.ssh/github";
      };

      gitlab-tu-dortmund = {
        host = "ls14-scm.cs.tu-dortmund.de";
        identityFile = "~/.ssh/gitlab_tu_dortmund";
      };
    };
  };

  # File associations
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };

  news.display = "silent";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
