{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      highlight = "fg=245";
    };
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 10000;
      save = 10000;
      extended = true;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    localVariables = {
      DISABLE_AUTO_UPDATE = true;
      DISABLE_MAGIC_FUNCTIONS = true;
      PROMPT_EOL_MARK = "";
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "colored-man-pages"
        "docker"
        "docker-compose"
        "git"
        "kubectl"
        "vagrant"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        # Powerlevel10k instant prompt must run before Oh My Zsh.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkOrder 1000 ''
        [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
        source ${../dotfiles/zsh/functions.zsh}

        bindkey jj vi-cmd-mode

        # Keep user-managed tools available after the Nix and Homebrew paths.
        [[ -d "$HOME/bin" ]] && path+=("$HOME/bin")
        [[ -d "$HOME/go/bin" ]] && path+=("$HOME/go/bin")
        [[ -d "$HOME/.krew/bin" ]] && path+=("$HOME/.krew/bin")
        [[ -d "$HOME/.local/share/coursier/bin" ]] && path+=("$HOME/.local/share/coursier/bin")
        [[ -d "$HOME/.local/share/nvim/mason/bin" ]] && path+=("$HOME/.local/share/nvim/mason/bin")
        [[ -d "/opt/homebrew/opt/libpq/bin" ]] && path+=("/opt/homebrew/opt/libpq/bin")

        if [[ -x "$HOME/go/bin/ssh-tunnel-manager" ]]; then
          autoload -U +X bashcompinit && bashcompinit
          complete -o nospace -C "$HOME/go/bin/ssh-tunnel-manager" ssh-tunnel-manager tm
        fi

      '')
    ];

    profileExtra = ''
      # Keep Homebrew available for packages that have not moved to Nix yet,
      # but do not let its bin directories shadow declaratively managed tools.
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      typeset -U path
      path=(
        "$HOME/.nix-profile/bin"
        "/etc/profiles/per-user/$USER/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        $path
      )
    '';

    shellAliases = {
      docker-compose = "docker compose";
      fzf = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window=right:65%";
      gcm = "git commit -m";
      gpl = "git pull";
      glc = "git add .; git commit --amend --no-edit";
      glog = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      k = "kubectl";
      ll = "eza --long --all --group-directories-first";
      o = "open";
      rebuild = "make -C ~/nix-macos apply";
      t = "tree";
      nix-shell = "nix-shell --run zsh";
    };
  };

  programs.starship = {
    enable = true;
    # The imported legacy config currently uses Powerlevel10k as its prompt.
    enableZshIntegration = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type file --follow --hidden --exclude .git";
    fileWidgetCommand = "fd --type file --follow --hidden --exclude .git";
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };
}
