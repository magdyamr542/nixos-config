{
  pkgs,
  ...
}: {
  # System packages
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
    xsel
  ];
}
