{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ./hardware-builder.nix
    ./system-packages.nix
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  networking = {
    hostName = "amr";
    networkmanager.enable = true;
  };
  programs.nm-applet.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    amr = {
      description     = "My user";
      name            = "amr";
      group           = "amr";
      extraGroups     = ["wheel" "docker" "networkmanager" "audio"];
      password        = builtins.readFile(./users/amr/password.txt);
      home            = "/home/amr";
      createHome      = true;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOT+/Bl0QBOJCJZG+EoZENziljwEg74RbZXw8bjWgIlk magdyamr542@gmail.com"
      ];
      isNormalUser = true;
    };
  };


  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
    mouse.accelSpeed = "0.8";
    touchpad.accelSpeed = "0.8";
  };

  users.groups = {
    amr = {
      name = "amr";
      members = [ "amr" ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu i3status i3lock i3blocks
      ];
    };
  };

  services.displayManager = {
      enable = true;
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "amr";
      };
  };

  programs.zsh.enable = true;
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

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
        LC_CTYPE="en_US.utf8"; # required by dmenu don't change this
      };
    };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
