{ pkgs, ... }:
{
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host github.com
        AddKeysToAgent yes
        IdentityFile ~/.ssh/github

      Host ls14-scm.cs.tu-dortmund.de
        AddKeysToAgent yes
        IdentityFile ~/.ssh/gitlab_tu_dortmund
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
