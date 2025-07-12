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
        exec = "chromium --ozone-platform-hint=wayland --app=https://listen.tidal.com";
        icon = "/home/emily/.local/share/xdg-desktop-portal/icons/tidal.png"; 
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
        "Mod+O"       = { hotkey-overlay.title ="Toggle overview";                action = toggle-overview; };
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
        default-window-height.fixed = 250;
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
      width = 500;
      font = "Hack Nerd Font"  ;
      border-color = "#b7bdf8"; # Catppuccin lavender
      background-color = "#363a4f"; # Cappuccin surface 0
      default-timeout=7500;
      ignore-timeout=1;
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

  # Going to add more stuff to waybar:
  # Battery, custom-media maybe?
  # Probably not workspaces
  # Power profiles daemon
  # Maybe try to fix so I can have separate borders for left module and for niri/window
  # bottom bar? not sure what i would have there but big screen 
  #temperature maybe
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.service";
    };

    settings.mainBar = {
      height = 40;
      spacing = 20;

      layer = "top";
      modules-left = [
        "tray"
        "battery"
        "niri/window"
      ];
      # modules-center = [
      #   "niri/window"
      # ];
      modules-right = [
        "pulseaudio" "pulseaudio/slider"
        "network"
        "bluetooth"
        "clock"
      ];
      "niri/window" = {
        icon = true;
        icon-size = 24;
        rewrite = {
          "(.*) (:?— Mozilla (Firefox|Thunderbird)|- Quod Libet)" = "$1"; # remove some titles
          "• Discord \\| ([^|]*) \\| (.*)" = "$2 ⟩ $1"; # discord formats things as Discord | Channel | Server
          "• Discord \\| ([^|]*)" = "$1"; # sometimes there's no server to show
          # pinged versions
          "\\((\\d+)\\) Discord \\| ([^|]*) \\| (.*)" = "$3 ⟩ $2 ($1)";
          "\\((\\d+)\\) Discord \\| ([^|]*)" = "$2 ($1)";
        };
      };

      pulseaudio = {
          format = "{icon}";
          format-alt = "{volume} {icon}";
          format-alt-click = "click-right";
          format-muted = "🔇";
          format-icons = {
              default = ["" "" ""];
          };
          scroll-step = 10;
          on-click = "pwvucontrol";
          tooltip = false;
      };
      network = {
        format = "{icon}";
        format-alt = "{ipaddr}/{cidr} {icon}";
        format-alt-click = "click-right";
        format-icons = {
            wifi = [" "];
            ethernet = ["󰛳"];
        };
        on-click = "alacritty -e nmtui";
        tooltip = false;
      };
      bluetooth = {
        on-click = "blueberry";
        format = "";
      };
      clock = {
          format = "{:%a %d %b %H:%M}";
          tooltip = false;
      };
      battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          format-charging = "{capacity}% 󰂅";
          interval = 30;
          states = {
              warning = 25;
              critical = 1;
          };
          tooltip = false;
      };
      tray = {
          icon-size = 24;
          spacing = 10;
      };
    };
    style = ''
      @define-color   pink     #f5bde6;
      @define-color   mauve    #c6a0f6;
      @define-color   lavender #b7bdf8;
      @define-color   red      #ed8796;
      @define-color   maroon   #ee99a0;
      @define-color   peach    #f5a97f;
      @define-color   yellow   #eed49f;

      @define-color   text     #cad3f5;
      @define-color   subtext1 #b8c0e0;
      @define-color   subtext0 #a5adcb;

      @define-color   overlay0 #6e738d;
      @define-color   overlay1 #8087a2;
      @define-color   overlay2 #939ab7;

      @define-color   surface0 #363a4f;
      @define-color   surface1 #494d64;
      @define-color   surface2 #5b6078;

      @define-color   base     #24273a;
      @define-color   mantle   #1e2030;
      @define-color   crust    #181926;

      * {
          font-size:18px;
          font-family: "Hack Nerd Font";
      }

      window#waybar {
        background-color: rgba(0,0,0,0);
        color: @text;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* for tray */
      menu {
          background-color: rgba(123, 162, 170, 0.8);
          color: rgba(35, 31, 32, 1);
      }
      menu :disabled {
          color: rgba(95, 91, 92, 1);
      }

      .modules-left {
          padding-left: 10px;
          padding-right: 10px;
          margin:10 0 0 10;
          border-radius:10px;
          background: alpha(@mantle,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
      }

      /*
      .modules-center {
          padding-left: 10px;
          padding-right: 10px;
          margin:10 0 0 0;
          border-radius:10px;
          background: alpha(@mantle,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
      }
      */

      .modules-right {
          padding-left: 10px;
          padding-right: 10px;
          margin:10 10 0 0;
          border-radius:10px;
          background: alpha(@mantle,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
      }

      #pulseaudio-slider {
          min-width: 100px;
      }

      /* don't show the grabbable thing in the slider */
      #pulseaudio-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
      }

      #pulseaudio-slider trough {
          min-height: 15px;
          min-width: 10px;
          border-radius: 5px;
          background-color: @crust;
      }
      #pulseaudio-slider highlight {
          min-width: 10px;
          border-radius: 5px;
          background-color: rgba(247, 246, 246, 1);
      }

      * {
          border:        none;
          border-radius: 0;
          box-shadow:    none;
          text-shadow:   none;
          transition-duration: 0s;
      }

      #battery {
          padding-right: 10px;
      }

      #battery.warning {
         color:       @peach; 
      }

      #battery.critical {
          color:      @red;
      }
      

    '';
    };
}
