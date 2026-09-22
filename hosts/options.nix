# Schema for the per-host records under hosts/*.nix.
#
# Each hosts/*.nix file is a plain attribute set (no `{ ... }:` function head)
# evaluated against these options via `lib.evalModules` in flake.nix. That
# gives every field a declared type, an optional default, and a description,
# so a typo or a wrong-shaped value fails at evaluation time with a precise
# error pointing at the offending option instead of surfacing later as a
# missing-attribute error deep inside nixos/, darwin/, or home/.
{ lib, ... }:
{
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Unix username the system and Home Manager configuration are built for.";
      example = "amr";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname (NixOS `networking.hostName` / macOS `networking.*HostName`).";
      example = "amr";
    };

    system = lib.mkOption {
      type = lib.types.str;
      description = ''
        Nix system double for this host, matching one of the entries in
        `supportedSystems` in flake.nix (e.g. "x86_64-linux", "aarch64-darwin").
      '';
      example = "x86_64-linux";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      description = "Absolute path to the user's home directory on the target machine.";
      example = "/home/amr";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "Home Manager `home.stateVersion` compatibility marker. Do not change routinely.";
      example = "23.05";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git author name. Leave empty to skip managing Git identity.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git author email. Leave empty to skip managing Git identity.";
    };

    gitSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Extra settings merged into `programs.git.settings` (Home Manager).";
    };

    sshSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = { };
      description = ''
        Passed verbatim to `programs.ssh.settings` (Home Manager). Keys are
        host patterns (e.g. "github.com", "*"); values are per-host SSH options.
      '';
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Unix groups for the user. NixOS hosts only.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Public SSH keys authorized for the user's account. NixOS hosts only.";
    };

    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        sops-encrypted secrets file read by both the system (NixOS) and Home
        Manager, or null to disable sops on this host. Decryption uses the age
        key at ~/.config/sops/age/keys.txt on the target machine.
      '';
      example = lib.literalExpression "../secrets/secrets.yaml";
    };

    passwordHashSecret = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Name of the secret in `sopsFile` holding the user's yescrypt password
        hash, or null to leave the account without one (e.g. when another
        mechanism, like Vagrant, manages login). NixOS hosts only.
      '';
      example = "amr-password-hash";
    };

    homeModule = lib.mkOption {
      type = lib.types.path;
      description = "Home Manager entry module for this host (e.g. home/linux or home/darwin).";
    };

    nixosModule = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "NixOS system module for this host. Set for Linux hosts, left null on macOS.";
    };

    darwinModule = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "nix-darwin system module for this host. Set for macOS hosts, left null on Linux.";
    };
  };
}
