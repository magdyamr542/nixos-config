{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # TODO: MUST migrate this legacy configuration to Home Manager/Nix
    # modules, then remove dotfiles/nvim/init.lua and this direct import.
    initLua = builtins.readFile ../../dotfiles/nvim/init.lua;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # TODO: MUST migrate these legacy host blocks to programs.ssh.settings,
    # then remove dotfiles/ssh/config and this direct import.
    extraConfig = builtins.readFile ../../dotfiles/ssh/config;

    settings."*" = {
      AddKeysToAgent = "yes";
      Compression = false;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
    };
  };
}
