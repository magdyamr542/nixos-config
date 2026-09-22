{
  inputs,
  lib,
  config,
  host,
  outputs,
  pkgs,
  ...
}:
{

  # You can import other NixOS modules here
  imports = [
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/secrets.nix
    ./modules/security.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit host inputs outputs; };
    users.${host.username} = import ../home;
  };

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    ${host.username} = {
      description = "User ${host.username}";
      name = host.username;
      group = host.username;
      extraGroups = host.extraGroups;
      home = "/home/${host.username}";
      createHome = true;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = host.authorizedKeys;
      isNormalUser = true;
    };
  };

  users.groups = {
    ${host.username} = {
      name = host.username;
      members = [ host.username ];
    };
  };

  programs.zsh.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
      LC_CTYPE = "en_US.utf8"; # required by dmenu don't change this
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
