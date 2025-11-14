{ theme, ... }:
{
  # Notification Daemon
  services.mako = {
    enable = true;
    settings = {
      border-radius = 10;
      border-size =  2;
      margin = "30";
      width = 500;
      font = "Hack Nerd Font"  ;
      border-color = "#${theme.current.accent2}"; # Catppuccin lavender
      background-color = "#${theme.current.surface0}E0"; # Cappuccin surface 0
      default-timeout=7500;
      ignore-timeout=0;
      "mode=dnd" = {
        invisible = true;
      };
    };
  };
}
