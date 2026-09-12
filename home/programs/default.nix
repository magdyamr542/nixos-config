{
  imports = [ ./neovim.nix ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/lynqtech_github";
      };

      "turntable.*".Port = 22022;

      "*" = {
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
    };
  };
}
