{ pkgs, ... }:
{
  programs.ssh.startAgent = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
