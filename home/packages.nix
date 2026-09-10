{ pkgs, ... }:

{
  # Add or remove user-level CLI packages here, then run `make apply`.
  home.packages = with pkgs; [
    bat
    curl
    eza
    fd
    fzf
    htop
    jq
    ripgrep
    tree
    wget
  ];
}
