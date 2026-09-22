{
  config,
  host,
  lib,
  ...
}:

{
  # Declare user secrets as `sops.secrets."<name>" = { };` and reference them
  # through `config.sops.secrets."<name>".path`; they are decrypted at login,
  # never copied into the Nix store.
  sops = lib.mkIf (host.sopsFile != null) {
    defaultSopsFile = host.sopsFile;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };
}
