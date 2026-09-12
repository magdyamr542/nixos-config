{ pkgs, ... }:
let
  customGoPrograms = pkgs.callPackage ../../packages { };
in
{

  # User packages
  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    zsh-completions
    alacritty
    arandr
    unzip
    wget
    bat
    diffutils
    fd
    google-chrome
    kubectl
    fastfetch
    powerline
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
    nixfmt
    maim
    file
    vlc
    gnumeric
    hypnotix
    lsof
    awscli2
    libsecret
    openssl_legacy
    ffmpeg
    keyutils
    dig
    unixtools.xxd
    pgcli
    codex
    ripgrep
    ghz
    kubectx
    sound-theme-freedesktop
    claude-code
    (pkgs.buildEnv {
      name = "my-bash-scripts";
      paths = [ ../../scripts ];
    })
  ];

}
