{ config, ... }:

{
  # The current ~/.zshrc is a symlink. Its resolved contents are preserved in
  # dotfiles/zsh/zshrc, so Home Manager may replace the link on first activation.
  home.file."./.zshrc" = {
    force = true;
    # Normalize the zsh module's internal "./.zshrc" key for collision checks.
    target = ".zshrc";
  };

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    # The imported legacy config loads both plugins through Oh My Zsh.
    # Re-enable these when that config is migrated to Home Manager modules.
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    # TODO: MUST migrate this legacy file to Home Manager/Nix modules, then
    # remove dotfiles/zsh/zshrc and this direct import.
    initContent = builtins.readFile ../dotfiles/zsh/zshrc;

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
      cat = "bat";
      ll = "eza --long --all --group-directories-first";
      rebuild = "make -C ~/nix-macos apply";
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
}
