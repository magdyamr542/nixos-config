{ host, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./programs
  ];

  home = {
    username = host.username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
      RIPGREP_CONFIG_PATH = "/Users/${host.username}/.config/ripgrep/ripgreprc";
    };
  };

  # Example for software without a Home Manager module.
  xdg.configFile."ripgrep/ripgreprc".source = ../dotfiles/ripgrep/ripgreprc;

  programs.home-manager.enable = true;
}
