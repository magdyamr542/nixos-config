{ pkgs, lib, ... }:
let
  customGoPrograms = pkgs.callPackage ./custom-programs/go.nix { };
  pkgsUnstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e06158e58f3adee28b139e9c2bcfcc41f8625b46.tar.gz";
    sha256 = "sha256:1bk0n27lzl8yfks4wdcm89pxqvjqcz2f1b8xyi8sd7mz59p96a9d"; 
  }) {
    system = pkgs.system;
  }; # a working version for teams-for-linux
in
{

  # User packages
  home.packages = with pkgs; [
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
    nerdfonts
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
    pkgsUnstable.teams-for-linux
    (pkgs.buildEnv {
      name = "my-bash-scripts";
      paths = [ ./scripts ];
    })
  ];

}
