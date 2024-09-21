{ ... }:
{
  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  users.users.amr.extraGroups = [ "vboxsf" ];
}
