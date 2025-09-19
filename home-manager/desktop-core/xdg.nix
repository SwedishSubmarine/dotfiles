{ pkgs, ... }:
{
  xdg = {
    mimeApps = {
      enable = true;
      associations.added = {
        "x-scheme-handler/mailto" = "userapp-Thunderbird-NYEK92.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-NYEK92.desktop";
        "x-scheme-handler/webcal" = "userapp-Thunderbird-JY1I92.desktop";
        "x-scheme-handler/webcals" = "userapp-Thunderbird-JY1I92.desktop";
      };
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        "x-scheme-handler/mailto" = "userapp-Thunderbird-NYEK92.desktop";
        "message/rfc822" = "userapp-Thunderbird-NYEK92.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-NYEK92.desktop";
        "x-scheme-handler/webcal" = "userapp-Thunderbird-JY1I92.desktop";
        "text/calendar" = "userapp-Thunderbird-JY1I92.desktop";
        "application/x-extension-ics" = "userapp-Thunderbird-JY1I92.desktop";
        "x-scheme-handler/webcals" = "userapp-Thunderbird-JY1I92.desktop";
      };
    };
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common = {
        default = [ "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    desktopEntries = {
      tidal = {
        name = "Tidal";
        exec = "${pkgs.chromium}/bin/chromium --ozone-platform-hint=wayland --app=https://listen.tidal.com";
        icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/48x48/apps/tidal.svg";
      };
      firefox = {
        name = "Firefox";
        exec = "${pkgs.firefox}/bin/firefox";
        icon = "firefox";
      };
      vesktop = {
        name = "Vesktop";
        exec = "${pkgs.vesktop}/bin/vesktop --ozone-platform-hint=wayland";
        icon = "vesktop";
      };
      vscode = {
        name = "VSCode";
        exec = "${pkgs.vscode}/bin/code --ozone-platform-hint=wayland";
        icon = "vscode";
      };
      calendar = {
        name = "Calendar";
        exec = "${pkgs.thunderbird}/bin/thunderbird -calendar";
        icon = "thunderbird";
      };
    };
  };
}
