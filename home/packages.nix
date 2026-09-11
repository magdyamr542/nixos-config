{ pkgs, lib, ... }:
let
  customGoPrograms = pkgs.callPackage ../packages { };
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
    rofi
    feh
    networkmanagerapplet
    picom
    pulseaudio
    xclip
    xdg-utils
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
    keyutils
    dig
    unixtools.xxd
    pgcli
    codex
    opencode
    ripgrep
    b3sum
    ghz
    kubectx
    sops
    k9s
    claude-code
    (pkgs.buildEnv {
      name = "my-bash-scripts";
      paths = [ ../scripts ];
    })
  ];

}
