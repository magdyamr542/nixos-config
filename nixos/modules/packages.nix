{ pkgs, ... }:
{
  # Packages needed by every local user or by system administration.
  environment.systemPackages = with pkgs; [
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync
    cmake
    curl
    docker-compose
    git
    nmap
    pdfgrep
    tree
    bumblebee-status
    brightnessctl
    xsel
    bc
    zip
  ];
}
