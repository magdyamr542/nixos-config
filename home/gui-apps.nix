{ pkgs, ... }:

{
  # GUI apps managed by Nix instead of Homebrew casks. Home Manager aliases
  # these into "~/Applications/Home Manager Apps" automatically.
  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
    claude-code
    dbeaver-bin
    drawio
    insomnia
    iterm2
    keepassxc
    keycastr
    nerd-fonts.hack
    ngrok
    vagrant
    vscode
  ];
}
