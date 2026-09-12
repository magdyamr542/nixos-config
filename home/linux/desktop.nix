{ ... }:

{
  home.file = {
    ".vrapperrc".source = ../../dotfiles/vrapper/vrapperrc;
    ".alacritty/alacritty.toml".source = ../../dotfiles/alacritty/alacritty.toml;
    ".alacritty/solarized_dark.toml".source = ../../dotfiles/alacritty/solarized_dark.toml;
    ".wallpaper.png".source = ../../dotfiles/i3/wallpaper.png;
    ".config/i3/config".source = ../../dotfiles/i3/config;
    ".config/rofi/config.rasi".source = ../../dotfiles/rofi/config.rasi;
    ".config/rofi/dracula.rasi".source = ../../dotfiles/rofi/dracula.rasi;
    ".config/rofi/nord.rasi".source = ../../dotfiles/rofi/nord.rasi;
    ".scripts/i3/screenshot.sh".source = ../../dotfiles/i3/scripts/screenshot.sh;
    ".scripts/i3/update-brithness.sh".source = ../../dotfiles/i3/scripts/update-brithness.sh;
    ".scripts/i3/update-volume.sh".source = ../../dotfiles/i3/scripts/update-volume.sh;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        font = "Droid Sans 10";
        format = "<b>%s</b>\\n%b";
        frame_color = "#555555";
        frame_width = 2;
        geometry = "500x5-5+30";
        horizontal_padding = 8;
        icon_position = "off";
        line_height = 0;
        markup = "full";
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        transparency = 10;
        word_wrap = true;
      };
      urgency_low = {
        background = "#1d1f21";
        foreground = "#4da1af";
        frame_color = "#4da1af";
        timeout = 10;
      };
      urgency_normal = {
        background = "#1d1f21";
        foreground = "#70a040";
        frame_color = "#70a040";
        timeout = 15;
      };
      urgency_critical = {
        background = "#1d1f21";
        foreground = "#dd5633";
        frame_color = "#dd5633";
        timeout = 0;
      };
      shortcuts = {
        context = "mod4+grave";
        close = "mod4+shift+space";
      };
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "MesloLGM Nerd Font Mono" ];
      sansSerif = [ "MesloLGM Nerd Font Mono" ];
      monospace = [ "MesloLGM Nerd Font Mono" ];
    };
  };

  xdg.desktopEntries.iptvnator = {
    name = "IPTVnator";
    genericName = "IPTV Player";
    comment = "Start IPTVnator locally";
    exec = "iptvnator";
    terminal = false;
    categories = [
      "AudioVideo"
      "Video"
    ];
    icon = "${../../dotfiles/icons/iptv.svg}";
  };

  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "image/png" = [ "feh.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
      "x-scheme-handler/http" = [
        "google-chrome-stable.desktop"
        "google-chrome.desktop"
      ];
      "x-scheme-handler/https" = [
        "google-chrome-stable.desktop"
        "google-chrome.desktop"
      ];
    };
  };

  systemd.user.startServices = "sd-switch";
}
