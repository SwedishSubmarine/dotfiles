{ ... }:
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
      border-color = "#b7bdf8"; # Catppuccin lavender
      background-color = "#363a4f"; # Cappuccin surface 0
      default-timeout=7500;
      ignore-timeout=1;
    };
  };
}
