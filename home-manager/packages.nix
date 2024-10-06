{ pkgs, lib, ... }:
let
  customGoPrograms = pkgs.callPackage ./custom-programs/go.nix { };
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
    vscode
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
    virtualbox
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
    (pkgs.buildEnv {
      name = "my-bash-scripts";
      paths = [ ./scripts ];
    })
  ];

}
