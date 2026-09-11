{ host, ... }:

{
  networking = {
    hostName = host.hostname;
    networkmanager.enable = true;
  };

  programs.nm-applet.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
