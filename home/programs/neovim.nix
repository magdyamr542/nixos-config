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

  # Keep parsers and their queries at the revision expected by the packaged
  # plugin. This removes mutable TSInstall/TSUpdate state from the data dir.
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    parsers: with parsers; [
      bash
      c
      go
      html
      javascript
      json
      lua
      markdown
      markdown_inline
      nix
      python
      rust
      typescript
      vim
    ]
  );
in
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      vscode-nvim
      nvim-autopairs
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
