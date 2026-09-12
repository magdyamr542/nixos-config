{
  # Change these values before applying this configuration on another Mac.
  username = "amr.metwally";
  hostname = "LYNQTECH-W7CDXHWKLG";
  system = "aarch64-darwin";
  darwinModule = ../darwin;
  homeModule = ../home/darwin;
  homeDirectory = "/Users/amr.metwally";
  stateVersion = "26.05";

  # Leave these empty if you do not want Git identity managed by Home Manager.
  fullName = "Amr Metwally";
  email = "amr.metwally@lynq.tech";

  gitSettings = {
    alias.crb = "rev-parse --abbrev-ref HEAD";
    core.pager = "delta";
    interactive.diffFilter = "delta --color-only --features=interactive";
    pull.rebase = false;
    url."git@github.com:enercity".insteadOf = "https://github.com/enercity";
  };

  sshSettings = {
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
}
