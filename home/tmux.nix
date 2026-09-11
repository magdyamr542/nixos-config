{ pkgs, ... }:

{
  home.packages = with pkgs; [ tmux ];

  xdg.configFile."tmux/tmux.conf".source = ../dotfiles/tmux/tmux.conf;
  xdg.configFile."tmux/tmux.conf.local".source = ../dotfiles/tmux/tmux.conf.local;
}
