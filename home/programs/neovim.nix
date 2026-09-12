{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
# Neovim configuration comes from the vendored git submodule of
# https://github.com/magdyamr542/nvim (home/programs/nvim-config). Plugin
# *installation* is managed here instead of by packer, so plugin versions are
# pinned and reproducible via nixpkgs rather than floating on whatever branch
# each plugin's upstream defaults to.
let
  nvimConfigDir = ./nvim-config;

  nvim-yati = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-yati";
    version = "unstable-2024";
    src = pkgs.fetchFromGitHub {
      owner = "yioneko";
      repo = "nvim-yati";
      rev = "df3dc06076c6fe20a1dcd8643e712af5c252d042";
      hash = "sha256-hsSGj/bKY0FxZi1BlJxa/U2zvJzOwrFSz1W/MUtPunU=";
    };
    # The require-check builds in isolation, without nvim-treesitter (a peer
    # plugin, not a dependency) on the runtimepath, so it always fails here.
    doCheck = false;
  };
in
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vscode-nvim
      auto-pairs
      vim-code-dark
      ayu-vim
      popup-nvim
      plenary-nvim
      telescope-nvim
      vim-polyglot
      nerdtree
      vim-illuminate
      vim-javascript
      typescript-vim
      gruvbox
      quick-scope
      vim-surround
      markdown-preview-nvim
      nightfox-nvim
      nvim-treesitter
      playground
      nvim-treesitter-context
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      cmp_luasnip
      luasnip
      cmp-nvim-lsp-signature-help
      vim-devicons
      bufferline-nvim
      nvim-web-devicons
      friendly-snippets
      nvim-yati
      nvim-scrollview
      neoscroll-nvim
      vim-visual-multi
      rose-pine
      indent-blankline-nvim
      lualine-nvim
      gitsigns-nvim
      fidget-nvim
      comment-nvim
      mason-nvim
      mason-lspconfig-nvim
      onedark-nvim
      nvim-colorizer-lua
    ];

    extraPackages = with pkgs; [
      tree-sitter
      nodejs
      # nodePackages.bash-language-server
      # nodePackages.typescript-language-server
      # lua-language-server
      # nodePackages.vscode-json-languageserver
      ripgrep
      black
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
}
