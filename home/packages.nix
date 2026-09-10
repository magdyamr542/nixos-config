{ pkgs, ... }:

{
  # Add or remove user-level CLI packages here, then run `make apply`.
  home.packages = with pkgs; [
    bat
    curl
    eza
    fd
    gh
    golangci-lint
    htop
    httpie
    jq
    protobuf
    rename
    ripgrep
    tldr
    tree
    wget
    yq-go
  ];
}
