{ host, ... }:
{
  # Enable VirtualBox guest additions for the current machine.
  virtualisation.virtualbox.guest.enable = true;
  users.users.${host.username}.extraGroups = [ "vboxsf" ];
}
