{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ./hardware-builder.nix
    ./system-packages.nix
    ./gpg.nix
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

  networking = {
    hostName = "amr";
    extraHosts = "127.0.0.1 gitos.local";
    networkmanager.enable = true;
    networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
    networkmanager.ensureProfiles.profiles.gitos = {
      connection = {
        id = "gitos";
        type = "vpn";
        permissions = "";
      };
      vpn = {
        service-type = "org.freedesktop.NetworkManager.openvpn";
        connection-type = "tls";
        dev = "tun";
        remote = "116.203.2.180";
        port = "1194";
        proto-tcp = "no";
        ca = "/etc/NetworkManager/openvpn/gitos/ca.crt";
        cert = "/etc/NetworkManager/openvpn/gitos/client.crt";
        key = "/etc/nixos/nixos/vpns/gitos/client.key";
        remote-cert-tls = "server";
        cipher = "AES-256-GCM";
        ping = "10";
        ping-restart = "60";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
  programs.nm-applet.enable = true;

  services.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    amr = {
      description = "User amr";
      name = "amr";
      group = "amr";
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "audio"
        "vboxusers"
      ];
      password = builtins.readFile (./users/amr/password.txt);
      home = "/home/amr";
      createHome = true;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOT+/Bl0QBOJCJZG+EoZENziljwEg74RbZXw8bjWgIlk magdyamr542@gmail.com"
      ];
      isNormalUser = true;
    };
  };

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = false;
    touchpad.naturalScrolling = true;
    mouse.accelSpeed = "0.6";
    touchpad.accelSpeed = "0.6";
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
    exportConfiguration = true;
    xkb.layout = "us,de,ara";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3blocks
      ];
    };
  };

  programs.i3lock = {
    enable = true;
  };

  services.displayManager = {
    enable = true;
    defaultSession = "none+i3";
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
    brightnessKeys.step = 5;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Virtualbox
  users.extraGroups.vboxusers.members = [ "amr" ];
  virtualisation.virtualbox.host.enable = true;

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

  # Virtual box networking config to work with Vagrant as described here:
  # https://github.com/techiescamp/vagrant-kubeadm-kubernetes
  environment.etc = {
    "vbox/networks.conf".text = "* 0.0.0.0/0 ::/0";
    "NetworkManager/openvpn/gitos/ca.crt".text = ''
      -----BEGIN CERTIFICATE-----
      MIIBhzCCAS6gAwIBAgIQf8AlHbNXUFSjo6KPiZqQFjAKBggqhkjOPQQDAjAkMQ4w
      DAYDVQQKEwVnaXRPUzESMBAGA1UEAxMJZ2l0b3MgVlBOMB4XDTI1MTIyMTE3MDQ1
      M1oXDTM1MTIxOTE3MDQ1M1owJDEOMAwGA1UEChMFZ2l0T1MxEjAQBgNVBAMTCWdp
      dG9zIFZQTjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABE3HiJeyKzAWRI7EMLpt
      /0vtxXxQ3SO2vJmjZ4GPFJnserJG6Nh4xJWnWPdn0zBbgFLPMpto9CkF0NCKRIMa
      5dKjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
      BBR/mnwZYPk+STo6PLuuMwGqB1KlKjAKBggqhkjOPQQDAgNHADBEAiBH7TBiiFPx
      17pXzLFj/Gw9XcSO+Um0FY0jCo01+w1KWQIgDQGsLwseho1pzGSBdUFSOF15H+6W
      SeE4dgC2szAF+98=
      -----END CERTIFICATE-----
    '';
    "NetworkManager/openvpn/gitos/client.crt".text = ''
      -----BEGIN CERTIFICATE-----
      MIIBozCCAUmgAwIBAgIQAmg2VR0FNeX28bW9bQPhzzAKBggqhkjOPQQDAjAkMQ4w
      DAYDVQQKEwVnaXRPUzESMBAGA1UEAxMJZ2l0b3MgVlBOMB4XDTI1MTIyMTE3MDQ1
      M1oXDTM1MTIxOTE3MDQ1M1owITEOMAwGA1UEChMFZ2l0T1MxDzANBgNVBAMTBmFk
      bS1hbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABAf0VbXE29IZcBHsXEPGICzr
      m5EG62rhd5fOtWPs0xPcCmITuOgmqVJIhnI+D+JX8QXQdOZZj6JKu3yeG+Kid3Oj
      YDBeMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUH
      AwIwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBR/mnwZYPk+STo6PLuuMwGqB1Kl
      KjAKBggqhkjOPQQDAgNIADBFAiEAnqWiO9uAIhyMY15MxJMYGk7guHTtq+dZUcr6
      fNWKvKUCIGv4r1xPELjhvMO0PgRHbae4ndcBWzBt9jfd34uxF9Ah
      -----END CERTIFICATE-----
    '';
  };

}
