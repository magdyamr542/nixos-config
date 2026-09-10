{
  host,
  lib,
  pkgs,
  self,
  ...
}:

{
  nixpkgs.hostPlatform = host.system;
  nixpkgs.config.allowUnfree = false;

  # Individually allowlisted unfree GUI apps migrated from Homebrew casks.
  # Keep this list minimal instead of flipping allowUnfree globally.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "claude-code"
      "ngrok"
      "vagrant"
      "vscode"
    ];

  # Keep only tools that every local user needs here. Developer tools belong
  # in home/packages.nix so they remain scoped to the configured user.
  environment.systemPackages = with pkgs; [ vim ];

  nix = {
    enable = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.trusted-users = [
      "root"
      host.username
    ];
  };

  programs.zsh.enable = true;

  users.users.${host.username} = {
    name = host.username;
    home = "/Users/${host.username}";
  };

  networking = {
    hostName = host.hostname;
    computerName = host.hostname;
    localHostName = host.hostname;
  };

  system = {
    primaryUser = host.username;
    configurationRevision = self.rev or self.dirtyRev or null;

    # Conservative examples; remove either line to leave that preference alone.
    defaults = {
      dock.autohide = false;
      finder.ShowPathbar = true;
    };

    # Do not change after the first activation without reading the release notes.
    stateVersion = 6;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit host; };
    users.${host.username} = import ../home;
  };
}
