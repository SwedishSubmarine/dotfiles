{  config, pkgs, ... }:
let 
  XWAYLAND_DISPLAY = ":3";
  tidal-icon = builtins.fetchurl {
    url = "https://icon-library.com/images/tidal-icon-png/tidal-icon-png-23.jpg";
    sha256 = "sha256:1v9dwqzp1n0cwpmxl95qmpnjpc1dhpws6binl1ix8inrqrdafphq"; 
  };
in
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
    dataFile."xdg-desktop-portal/icons/tidal.png".source = tidal-icon;
    desktopEntries = {
      tidal = {
        name = "Tidal";
        exec = "${pkgs.chromium}/bin/chromium --ozone-platform-hint=wayland --app=https://listen.tidal.com";
        icon = "/home/emily/.local/share/xdg-desktop-portal/icons/tidal.png"; 
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

  programs.niri.settings = {
    debug.render-drm-device = "/dev/dri/renderD128";

    # Input
    input = {
      keyboard = {
        xkb = {
          layout = "se";
          variant = "nodeadkeys";
          options = "caps:swapescape";
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
	      "Mod+E"       = { hotkey-overlay.title = "niri msg";          action = spawn "sh" "${./rofi/niri-action.sh}"; };

        # Utility and help
	      "Mod+Comma"   = { hotkey-overlay.title = "Show these hotkeys";    action = show-hotkey-overlay; };
        # Credit for this power-menu script https://github.com/jluttine/rofi-power-menu
	      "Mod+Escape"  = { hotkey-overlay.title = "Quit niri";             action = spawn "rofi" "-show" "power-menu" "-show-icons" "-modi" "power-menu:${./rofi/rofi-power-menu}"; };
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
        "Mod+Shift+H"  = { hotkey-overlay.title = "Consume or expel left";     action = consume-or-expel-window-left; };
        "Mod+Shift+L"  = { hotkey-overlay.title = "Consume or expel right";    action = consume-or-expel-window-right; };

        # Workspaces
        "Mod+J"       = { hotkey-overlay.title = "Focus window or workspace down"; action = focus-window-or-workspace-down; };
        "Mod+K"       = { hotkey-overlay.title = "Focus window or workspace up";   action = focus-window-or-workspace-up; };
        "Mod+Shift+J" = { hotkey-overlay.title = "Focus workspace down";           action = focus-workspace-down; };
        "Mod+Shift+K" = { hotkey-overlay.title = "Focus workspace up";             action = focus-workspace-up; };
        "Mod+Ctrl+J"  = { hotkey-overlay.title = "Move window or workspace down";  action = move-window-down-or-to-workspace-down; };
        "Mod+Ctrl+K"  = { hotkey-overlay.title = "Move window or workspace up";    action = move-window-up-or-to-workspace-up; };
        "Mod+O"       = { hotkey-overlay.title = "Toggle overview";                action = toggle-overview; };

        # Function row
        "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "s" "10%-"];
        "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "s" "10%+"];

        "XF86LaunchA".action = toggle-overview; 
        "XF86Search".action.spawn = ["sh" "${./rofi/web-search.sh}"];

        "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
        "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
        "XF86AudioNext".action.spawn = ["playerctl" "next"];

        "XF86AudioMute".action.spawn = ["pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"];
        "XF86AudioLowerVolume".action.spawn = ["pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%"];
        "XF86AudioRaiseVolume".action.spawn = ["pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%"];
	  };

    spawn-at-startup = [
	      { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" XWAYLAND_DISPLAY ]; }
	      # { command = [ "${x-wayland-clipboard-daemon}" ]; }
	      { command = [ "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" ]; } # needed for screen-sharing to work
	      { command = [ "systemctl" "--user" "start" "background" "nm-applet" ]; }
	    ];
      environment.DISPLAY = XWAYLAND_DISPLAY;
    
    prefer-no-csd = true;

    window-rules = [
      {
        default-column-width.proportion = 0.5;
        draw-border-with-background = false;
        geometry-corner-radius = 
          let rad = 10.0;
          in { bottom-left = rad; bottom-right = rad; top-right = rad; top-left = rad; };
        clip-to-geometry=true;
      }
      {
      excludes = [
        { title = '' - YouTube — Mozilla Firefox$''; }
        { title = '' - Twitch — Mozilla Firefox$''; }
        { app-id = ''^darktable$''; }
      ];
      }
      {
        matches = [ { app-id = "om.saivert.pwvucontrol"; } ];
        open-floating = true;
        default-window-height.proportion = 0.4;
        default-floating-position = {
          relative-to = "top-right";
          x = 20.0;
          y = 10.0;
        };
      }
      {
        matches = [ { app-id = "blueberry.py"; } ];
        open-floating = true;
        default-window-height.proportion = 0.4;
        default-floating-position = {
          relative-to = "top-right";
          x = 20.0;
          y = 10.0;
        };
      }
      {
        # Sorry alacritty nerds but i dont use this terminal
        matches = [ { app-id = "Alacritty"; } ];
        open-floating = true;
        default-window-height.proportion = 0.3;
        default-column-width.proportion = 0.4;
        focus-ring = {
          width = 2;
          active.color = "#b7bdf8";
        };
        default-floating-position = {
          relative-to = "top-right";
          x = 20.0;
          y = 10.0;
        };
      }
      {
        matches = [ { app-id = "org.wezfurlong.wezterm"; } ];
        default-window-height.proportion = 1.0;
      }
    ];

    layout = {
      focus-ring = {
        enable = true;
        width = 3;
        active.gradient = {
          from = "#b7bdf8";
          to = "#c6a0f6";
          angle = 0;
          "in'" = "srgb";
          relative-to = "workspace-view";
        };
      };
      shadow = {
        enable = true;
        color = "#00000071";
      };
      tab-indicator = {
        enable = true;
        width=5.0;
        gap=4.0;
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${./rofi/rounded.rasi}";
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
      width = 500;
      font = "Hack Nerd Font"  ;
      border-color = "#b7bdf8"; # Catppuccin lavender
      background-color = "#363a4f"; # Cappuccin surface 0
      default-timeout=7500;
      ignore-timeout=1;
    };
  };
}
