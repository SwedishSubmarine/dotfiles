{  config, pkgs, ... }:
let 
  XWAYLAND_DISPLAY = ":3";
in
{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.niri.settings = {
    debug.render-drm-device = "/dev/dri/renderD128";

    # Input
    input = {
      keyboard = {
        xkb = {
          layout = "se";
          variant = "nodeadkeys";
          options = "caps:escape";
        };
        repeat-rate = 50;
      };
      touchpad = {
        tap = false;
        click-method = "clickfinger";
        natural-scroll = false;
      };
    };

    outputs."eDP-1" = {
      scale = 1.5;
    };

    hotkey-overlay.hide-not-bound = true;
    binds = with config.lib.niri.actions; {
	      # Common programs
	      "Mod+Shift+T" = { hotkey-overlay.title = "Run wezterm"; action = spawn "wezterm"; };
	      "Mod+Shift+I" = { hotkey-overlay.title = "Run firefox";   action = spawn "firefox"; };
	
        # Launchers
	      "Mod+Space"   = { hotkey-overlay.title = "rofi launcher";     action = spawn "rofi" "-modes" "drun" "-show" "drun"; };
	      "Mod+E"       = { hotkey-overlay.title = "niri msg";          action = spawn "sh" "${./niri-action.sh}"; };

        # Utility and help
	      "Mod+Comma"   = { hotkey-overlay.title = "Show these hotkeys";    action = show-hotkey-overlay; };
	      "Mod+Escape"  = { hotkey-overlay.title = "Quit niri";             action = quit; };
	      "Mod+Q"       = { hotkey-overlay.title = "Close window";          action = close-window; };
        # "Mod+Shift+3" = { hotkey-overlay.title = "Screenshot screen";     action = screenshot-screen { write-to-disk = false; }; };
	      "Mod+Shift+4" = { hotkey-overlay.title = "Screenshot region";     action = screenshot; };
	      "Mod+Shift+5" = { hotkey-overlay.title = "Screenshot window";     action = screenshot-window { write-to-disk = false; }; };

        # Window and column size
	      "Mod+TouchpadScrollRight" = { hotkey-overlay.title = "Expand window"; action = set-window-width "+10"; };
	      "Mod+TouchpadScrollLeft"  = { hotkey-overlay.title = "Shrink window"; action = set-window-width "-10"; };
	      "Mod+TouchpadScrollUp"    = { hotkey-overlay.title = "Expand window"; action = set-window-height "+10"; };
	      "Mod+TouchpadScrollDown"  = { hotkey-overlay.title = "Shrink window"; action = set-window-height "-10"; };
        "Mod+R"       = { action = switch-preset-window-height; };
        "Mod+Shift+R" = { action = reset-window-height; };
	      "Mod+F"       = { hotkey-overlay.title = "Switch width";          action = switch-preset-column-width; };
        "Mod+Shift+F" = { hotkey-overlay.title = "Maximize Column";       action = maximize-column; };

        # No idea how tabs work, looking this up later
	      "Mod+T"       = { hotkey-overlay.title = "Switch to tabbed view"; action = toggle-column-tabbed-display; };
	      "Mod+Down"    = { hotkey-overlay.title = "Next tab";              action = focus-window-down; };
	      "Mod+Up"      = { hotkey-overlay.title = "Previous tab";          action = focus-window-up; };

        # Window and column movement
	      "Mod+Tab"     = { hotkey-overlay.title = "Focus last window";         action = focus-window-previous; };
        "Mod+H"       = { hotkey-overlay.title = "Focus Column to the Left";  action = focus-column-left;     };
        "Mod+L"       = { hotkey-overlay.title = "Focus Column to the Right"; action = focus-column-right;    };
        "Mod+Ctrl+H"  = { hotkey-overlay.title = "Move Column Left";          action = move-column-left;      };
        "Mod+Ctrl+L"  = { hotkey-overlay.title = "Move Column Right";         action = move-column-right;       };
        "Mod+V"       = { hotkey-overlay.title = "Toggle floating windows";   action = toggle-window-floating;  } ; 
        "Mod+Shift+V" = { hotkey-overlay.title = "Switch tiling/window focus";action = switch-focus-between-floating-and-tiling; } ; 
        # "       "     = { hotkey-overlay.title = "                 "; action =                      ; };
        "Mod+J"       = { hotkey-overlay.title ="Focus window or workspace down"; action = focus-window-or-workspace-down; };
        "Mod+K"       = { hotkey-overlay.title ="Focus window or workspace up";   action = focus-window-or-workspace-up; };
        "Mod+Ctrl+J"  = { hotkey-overlay.title ="Move window or workspace down";  action = move-window-down-or-to-workspace-down; };
        "Mod+Ctrl+K"  = { hotkey-overlay.title ="Move window or workspace up";    action = move-window-up-or-to-workspace-up; };
	  };

    spawn-at-startup = [
	      { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" XWAYLAND_DISPLAY ]; }
	      # { command = [ "${x-wayland-clipboard-daemon}" ]; }
	      { command = [ "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" ]; } # needed for screen-sharing to work
	      { command = [ "systemctl" "--user" "start" "background" "nm-applet" ]; }
	    ];
      environment.DISPLAY = XWAYLAND_DISPLAY;
    
    prefer-no-csd = true;

  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${./rounded.rasi}";
    extraConfig = {
      matching = "fuzzy";
    };
  };

  services.mako = {
    enable = true;
    settings = {
      border-radius = 10;
      border-size =  2;
      margin = "30";
      width = 600;
      # font = " "  ;
      # borderColor = " "  ; 
      # backgroundColor = " " ; 
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.service";
    };
  };

  systemd.user.services.nm-applet = {
	    Unit = {
	      Description = "Network manager applet";
	    };
	    Service = {
	      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
	    };
	  };
}
