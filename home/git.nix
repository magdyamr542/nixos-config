{ host, lib, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
    }
    // lib.optionalAttrs (host.fullName != "") {
      user.name = host.fullName;
    }
    // lib.optionalAttrs (host.email != "") {
      user.email = host.email;
    };
  };
}
