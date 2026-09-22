{
  config,
  host,
  lib,
  ...
}:
{
  assertions = [
    {
      assertion = host.passwordHashSecret == null || host.sopsFile != null;
      message = "host ${host.hostname}: passwordHashSecret requires sopsFile to be set.";
    }
  ];

  sops = lib.mkIf (host.sopsFile != null) {
    defaultSopsFile = host.sopsFile;
    # The same personal age key decrypts system and Home Manager secrets.
    # /home lives on the root filesystem, so it is readable during early activation.
    age.keyFile = "${host.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ ];
    gnupg.sshKeyPaths = [ ];

    secrets = lib.optionalAttrs (host.passwordHashSecret != null) {
      ${host.passwordHashSecret}.neededForUsers = true;
    };
  };

  users.users.${host.username} = lib.mkIf (host.sopsFile != null && host.passwordHashSecret != null) {
    hashedPasswordFile = config.sops.secrets.${host.passwordHashSecret}.path;
  };
}
