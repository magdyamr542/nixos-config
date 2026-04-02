{
  lib,
  config,
  pkgs,
  ...
}:
let
  gitosPublicKey = pkgs.writeText "gitos.public.asc" ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    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
    =06qX
    -----END PGP PUBLIC KEY BLOCK-----
  '';

  gpgKeys = [
    {
      name = "gitos";
      fingerprint = "86574767979F58953067131DDDEA4243D182237F";
      publicKeyFile = gitosPublicKey;
      privateKeyFile = "/etc/nixos/home-manager/users/amr/gpg/gitos.private.asc";
    }
  ];

  importGpgKeySnippet =
    key:
    let
      fingerprint = lib.escapeShellArg key.fingerprint;
      publicKeyFile = lib.escapeShellArg key.publicKeyFile;
      privateKeyFile = lib.escapeShellArg key.privateKeyFile;
      keyName = lib.escapeShellArg key.name;
    in
    ''
      if [ ! -f ${publicKeyFile} ] || [ ! -f ${privateKeyFile} ]; then
        echo "Skipping GPG key ${keyName}: expected files are missing."
      else
        fingerprint=${fingerprint}

        if ! ${config.programs.gpg.package}/bin/gpg --batch --list-secret-keys --with-colons "$fingerprint" | ${pkgs.gnugrep}/bin/grep -q '^sec'; then
          echo "Importing GPG key ${keyName} ($fingerprint)."
          ${config.programs.gpg.package}/bin/gpg --batch --import ${publicKeyFile}
          ${config.programs.gpg.package}/bin/gpg --batch --import ${privateKeyFile}
        fi

        if ! ${config.programs.gpg.package}/bin/gpg --batch --export-ownertrust | ${pkgs.gnugrep}/bin/grep -q "^$fingerprint:6:"; then
          printf '%s:6:\n' "$fingerprint" | ${config.programs.gpg.package}/bin/gpg --batch --import-ownertrust
        fi
      fi
    '';
in
{
  programs.gpg.enable = true;

  home.activation.importGpgKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    ''
      ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.gnupg"
      ${pkgs.coreutils}/bin/chmod 700 "${config.home.homeDirectory}/.gnupg"
    ''
    + lib.concatMapStrings importGpgKeySnippet gpgKeys
  );
}
