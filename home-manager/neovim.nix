{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
  # Fetch neovim configuration from my github repo at https://github.com/magdyamr542/nvim
  let nvimConfigDir = pkgs.fetchFromGitHub {
    owner = "magdyamr542";
    repo = "nvim";
    rev = "fd14ba49e2172fb2b5ed58d578251bab3a1c9d60";
    hash = "sha256-VzYC3JJjmTTbGw4ySFIgAOdBGNcVXUf0bSddHEDWPCk=";
  };
in 
{

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
         # I manage the plugins using packer
         # TODO: if i switch to using home manager to manage plugins, uncomment the lines below.
        packer-nvim
        # vscode-nvim
        # nvim-autopairs
        # vim-code-dark
        # ayu-vim
        # popup-nvim
        # plenary-nvim
        # telescope-nvim
        # vim-polyglot
        # nerdtree
        # vim-illuminate
        # vim-javascript
        # typescript-vim
        # gruvbox
        # quick-scope
        # vim-surround
        # markdown-preview-nvim
        # nightfox-nvim
        # nvim-treesitter.withAllGrammars
        # nvim-lspconfig
        # cmp-nvim-lsp
        # cmp-buffer
        # cmp-path
        # cmp-cmdline
        # nvim-cmp
        # cmp_luasnip
        # cmp-nvim-lsp-signature-help
        # vim-devicons
        # bufferline-nvim
        # nvim-web-devicons
        # friendly-snippets
        # nvim-scrollview
        # neoscroll-nvim
        # vim-visual-multi
        # indent-blankline-nvim
        # lualine-nvim
        # gitsigns-nvim
        # fidget-nvim
        # comment-nvim
        # mason-nvim
        # mason-lspconfig-nvim
        # onedark-nvim
        # nvim-colorizer-lua
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
      source = "${nvimConfigDir}";
      recursive = true;
    };
}