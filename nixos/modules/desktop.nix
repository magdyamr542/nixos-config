{ pkgs, ... }:

{
  services.pulseaudio.enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = false;
    touchpad.naturalScrolling = true;
    mouse.accelSpeed = "0.6";
    touchpad.accelSpeed = "0.6";
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    xkb.layout = "us,de,ara";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3blocks
      ];
    };
  };

  programs.i3lock.enable = true;

  services.displayManager = {
    enable = true;
    defaultSession = "none+i3";
  };

  programs.dconf.enable = true;
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
    brightnessKeys.step = 5;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-gstreamer
    ];
  };
}
