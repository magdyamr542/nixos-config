{ pkgs, ... }:

let
  # Fetch neovim configuration from https://github.com/magdyamr542/nvim
  nvimConfigDir = pkgs.fetchFromGitHub {
    owner = "magdyamr542";
    repo = "nvim";
    rev = "c88061c347aa1b336edb41dc610c7e63dc876a84";
    hash = "sha256-GqmBVXlxUK5RQ3H/VY4Vt6n1yz2uQuXWCkAoLahec50=";
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Plugins are managed with packer inside the fetched config; only
    # packer itself needs to be on the runtimepath for `packadd` to work.
    plugins = with pkgs.vimPlugins; [ packer-nvim ];

    extraPackages = with pkgs; [
      nodejs
      tree-sitter
    ];

    # source config entry point
    extraConfig = ''
      :luafile ~/.config/nvim/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = nvimConfigDir;
    recursive = true;
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
