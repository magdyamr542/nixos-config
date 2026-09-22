{ host, ... }:

{
  imports = [
    host.homeModule
    ./git.nix
    ./secrets.nix
    ./tmux.nix
    ./programs
  ];

  home = {
    inherit (host) username homeDirectory stateVersion;
  };

  home.file.".p10k.zsh".source = ../dotfiles/zsh/p10k.zsh;

  programs.home-manager.enable = true;
  news.display = "silent";
}
