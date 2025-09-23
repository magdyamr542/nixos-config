{ pkgs, lib, ... }:
let
  customGoPrograms = pkgs.callPackage ./custom-programs/go.nix { };
in
{

  # User packages
  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    zsh-autosuggestions
    zsh-completions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    tmux
    alacritty
    arandr
    unzip
    wget
    bat
    diffutils
    fd
    google-chrome
    insomnia
    kubectl
    neofetch
    ngrok
    powerline
    slack
    zoom-us
    vagrant
    vokoscreen-ng
    gcc
    python3
    go
    gopls
    gotools
    delve
    autojump
    delta
    rofi
    feh
    networkmanagerapplet
    picom
    pulseaudio
    xclip
    libnotify
    kustomize
    nix-prefetch-git
    customGoPrograms.ssh-tunnel-manager
    customGoPrograms.browser-tab-groups
    customGoPrograms.project-root
    customGoPrograms.clrd
    nodejs
    imagemagick
    yq
    nixfmt-rfc-style
    maim
    evince
    file
    vlc
    brave
    gnumeric
    hypnotix
    lsof
    dbeaver-bin
    teams-for-linux
    awscli2
    libsecret
    openssl_legacy
    ffmpeg
    rust-analyzer
    git-lfs
    (pkgs.buildEnv {
      name = "my-bash-scripts";
      paths = [ ./scripts ];
    })
  ];

}
