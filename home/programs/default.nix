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

    settings = {
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/lynqtech_github";
      };

      "turntable.*".Port = 22022;

      "*" = {
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
    };
  };
}
