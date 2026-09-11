{ host, ... }:

{
  virtualisation.docker.enable = true;

  users.extraGroups.vboxusers.members = [ host.username ];
  virtualisation.virtualbox.host.enable = true;

  # Allow Vagrant-managed VirtualBox networks on any address range.
  environment.etc."vbox/networks.conf".text = "* 0.0.0.0/0 ::/0";
}
