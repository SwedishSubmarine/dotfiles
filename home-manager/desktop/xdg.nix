{ config, pkgs, ... }:
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    desktopEntries = {
      tidal = {
        name = "Tidal";
        exec = "${pkgs.chromium}/bin/chromium --ozone-platform-hint=wayland --app=https://listen.tidal.com";
      };
      firefox = {
        name = "Firefox";
        exec = "${pkgs.firefox}/bin/firefox";
      };
      vesktop = {
        name = "Vesktop";
        exec = "${pkgs.vesktop}/bin/vesktop --ozone-platform-hint=wayland";
      };
    };
  };
}
