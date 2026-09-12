# VirtualBox hardware settings for the nixbox/nixos 24.05 Vagrant base box.
{ lib, ... }:

{
  # Avoid the shrunk-modules initrd bug in the pinned NixOS 25.11 revision.
  boot.initrd.includeDefaultModules = false;

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "sd_mod"
    "sr_mod"
  ];

  # includeDefaultModules = false above also skips upstream's default
  # `kernelModules = [ "dm_mod" ]`, so the initrd never loads the
  # device-mapper driver. Re-add it explicitly so udev can probe disks
  # without failing to reach /dev/mapper/control.
  boot.initrd.kernelModules = [ "dm_mod" ];

  # This box's disk gets a fresh filesystem UUID on every fetch/instantiation
  # (a hardcoded by-uuid path went stale and left root unable to mount at
  # boot), so mount by device path instead, matching the box's own
  # factory-generated hardware-configuration.nix.
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
    autoResize = true;
  };

  # Grow the root partition and filesystem to fill the Vagrant-resized 80GB
  # disk automatically on every boot, instead of running growpart/resize2fs
  # by hand.
  boot.growPartition = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
