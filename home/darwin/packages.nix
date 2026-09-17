{ pkgs, ... }:

{
  # Add or remove user-level CLI packages here, then run `make apply`.
  home.packages = with pkgs; [
    awscli2
    bat
    bitwarden-cli
    curl
    docker-client
    eza
    fd
    gh
    golangci-lint
    htop
    httpie
    jq
    kubectx
    libpq
    mirrord
    nmap
    nixfmt
    pgbouncer
    protobuf
    python311
    rename
    ripgrep
    tenv
    tesseract
    tflint
    tfsec
    tldr
    tree
    trivy
    wget
    yq-go
  ];
}
