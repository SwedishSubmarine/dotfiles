{  config, pkgs, ... }:
let 
  XWAYLAND_DISPLAY = ":3";
in
{
  imports = [
    ./rofi/rofi.nix
    ./mako.nix
  ];

  # Window manager
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
      "Mod+Space"   = { hotkey-overlay.title = "rofi launcher";     action = spawn "rofi" "-modes" "drun" "-show" "drun" "-icon-theme" ''"Papirus"'' "-show-icons"; };
      "Mod+E"       = { hotkey-overlay.title = "niri msg";          action = spawn "sh" "${./rofi/niri-action.sh}"; };
      "Alt+Tab"     = { hotkey-overlay.title = "rofi window";       action = spawn "rofi" "-show" "window" "-icon-theme" ''"Papirus"'' "-show-icons"; };

      # Utility and help
      "Mod+Comma"   = { hotkey-overlay.title = "Show these hotkeys";    action = show-hotkey-overlay; };
      # Credit for this power-menu script https://github.com/jluttine/rofi-power-menu
      "Mod+Escape"  = { hotkey-overlay.title = "Quit niri";             action = spawn "rofi" "-show" "power-menu" "-show-icons" "-modi" "power-menu:${./rofi/rofi-power-menu}"; };
      "Mod+Q"       = { hotkey-overlay.title = "Close window";          action = close-window; };
      
      # Screenshots, screenshot-screen is bronken so doing this until it's fixed
      "Mod+Shift+3" = { hotkey-overlay.title = "Screenshot screen";     action = spawn ["niri" "msg" "action" "screenshot-screen"]; };
      "Mod+Shift+4" = { hotkey-overlay.title = "Screenshot region";     action = screenshot; };
      "Mod+Shift+5" = { hotkey-overlay.title = "Screenshot window";     action = screenshot-window { write-to-disk = false; }; };
      "XF86AudioMicMute" = { hotkey-overlay.title = "Change wallpaper"; action = spawn "systemctl" "--user" "start" "wallpaper.service"; };

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

      # Dynamic screen cast
      "Mod+M"       = { hotkey-overlay.title = "Dynamic cast window";            action = set-dynamic-cast-window; };
      "Mod+Shift+M" = { hotkey-overlay.title = "Dynamic cast monitor";           action = set-dynamic-cast-monitor; };
      "Mod+Shift+C" = { hotkey-overlay.title = "Clear dynamic cast target";      action = clear-dynamic-cast-target; };

      # Function row
      "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "s" "10%-"];
      "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "s" "10%+"];

      "XF86LaunchA".action = toggle-overview; 
      "XF86Search".action.spawn = ["sh" "${./rofi/web-search.sh}"];
      "XF86Sleep".action.spawn = ["sh" "-c" "niri msg action do-screen-transition && swaylock"];

      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
      "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
      "XF86AudioNext".action.spawn = ["playerctl" "next"];

      "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_SINK@" "toggle"];
      "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_SINK@" "5%-"];
      "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_SINK@" "5%+"];
	  };

    switch-events = with config.lib.niri.actions; {
      "lid-close" = { action = spawn "sh" "-c" "niri msg action do-screen-transition && swaylock"; };
    };

    spawn-at-startup = [
	      { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" XWAYLAND_DISPLAY ]; }
	      # { command = [ "${x-wayland-clipboard-daemon}" ]; }
	      { command = [ "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" ]; } # needed for screen-sharing to work
	      { command = [ "systemctl" "--user" "start" "background" "nm-applet" ]; }
        { command = [ "swww-daemon" ]; }
	    ];
      environment.DISPLAY = XWAYLAND_DISPLAY;
    
    prefer-no-csd = true;

    layer-rules = [ 
      {
        matches = [ { namespace = ''^swww-daemon$''; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^notifications$"; } ];
        block-out-from = "screencast";
      }
    ];

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
        matches = [ { app-id = "org.pulseaudio.pavucontrol"; } ];
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
        matches = [ { app-id = "thunderbird"; } ];
        default-window-height.proportion = 1.0;
        default-column-width.proportion = 1.0;
      }
      {
        matches = [ { app-id = "thunderbird"; title = "Edit Item"; } ];
        open-floating = true;
        default-window-height.proportion = 0.5;
        default-column-width.proportion = 0.3;
      }
      {
        matches = [ { app-id = "thunderbird"; title = "Write.*"; } ];
        open-floating = true;
        default-window-height.proportion = 0.9;
        default-column-width.proportion = 0.9;
      }
      {
        matches = [ { app-id = "org.wezfurlong.wezterm"; } ];
        default-window-height.proportion = 1.0;
      }
      {
        matches = [ { app-id = "vesktop"; } ];
        opacity = 0.965;
      }
      {
        matches = [ { app-id = "code"; } ];
        opacity = 0.95;
      }
    ];

    overview = {
      workspace-shadow.enable = false;
      zoom = 0.5;
    };

    layout = {
      empty-workspace-above-first = true;
      background-color = "transparent";
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

  # Random desktop wallpaper service
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Random Desktop Wallpaper";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${../../wallpapers/random-script.sh}";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.wallpaper = {
    Timer = {
      Unit = "wallpaper";
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
