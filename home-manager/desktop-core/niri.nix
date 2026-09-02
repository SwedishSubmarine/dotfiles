{ settings, config, pkgs, theme, unstable, ... }:
let
  XWAYLAND_DISPLAY = ":3";
  random-wallpaper = pkgs.writeScript "random-wallpaper" ''
    #!/bin/sh
    IMAGE="$(find ${theme.current.wallpapers} -type l \( -name '*.png' -o -name '*.jpg' \) | shuf -n 1)"
    echo "$IMAGE" # For debugging
    awww img "$IMAGE" --transition-type any --transition-fps 60
  '';
  calendar = pkgs.writeScript "calendar" ''
    # Stolen from Xenia again :3
    #!/bin/sh
    ID=$(niri msg -j windows | jq '[.[] | select(.app_id=="firefox") | .id] | last')
    if [ "$ID" != ""null"" ] ; then
        # firefox is open, switch to it
        niri msg action focus-window --id "$ID"
    fi

    xdg-open "https://calendar.google.com"
  '';

  switch-keyboard-layout = pkgs.writeScript "keyboard-layout" ''
    #!/usr/bin/env bash

    NEXT=$((($(niri msg keyboard-layouts | grep -e '\*' | awk '{print $2}')+1) % 3))
    niri msg action switch-layout $NEXT
    NEW=$(niri msg keyboard-layouts | grep -e '\*' | awk '{$1="";  $2=""; print $0}')
    notify-send -t 3500 "Keyboard layout switched to:
    $NEW"
  '';
in
{
  imports = [
    ./rofi/rofi.nix
    ./mako.nix
    ./waybar.nix
    ./xdg.nix
  ];

  # Window manager
  wayland.windowManager.niri.enable = true;
  wayland.windowManager.niri.settings = {
    debug.render-drm-device = "/dev/dri/renderD128";
    debug.deactivate-unfocused-windows = [];

    # Input
    cursor = {
      xcursor-size = 48;
    };
    input = {
      keyboard = {
      xkb = {
        layout = "se,se,us(euro)";
        variant = "nodeadkeys,";
        options = "caps:swapescape";
      };
        repeat-rate = 50;
      };
      touchpad = {
        click-method = "clickfinger";
        dwt = {};
      };
    };

    hotkey-overlay.hide-not-bound = true;
    binds = with config.lib.niri.actions; {
      # Common programs
      "Mod+Shift+T" = {
        _props.hotkey-overlay-title = "Run wezterm";
        spawn = ["wezterm"];
      };
      "Mod+Shift+I" = {
        _props.hotkey-overlay-title = "Run firefox";
        spawn = ["firefox"];
      };
      "Mod+B" = {
        _props.hotkey-overlay-title = "Run rofi-rbw";
        spawn = ["rofi-rbw"];
      };
      "Mod+Shift+B" = {
        _props.hotkey-overlay-title = "Run bitwarden gui";
        spawn = ["bitwarden"];
      };

      # Launcher and scripts
      "Mod+Space" = {
        _props.hotkey-overlay-title = "rofi launcher";
        spawn = ["rofi" "-modes" "drun" "-show" "drun" "-icon-theme" ''"Papirus"'' "-show-icons"];
      };
      "Alt+Space" = {
        spawn = ["sh" "${switch-keyboard-layout}"];
      };
      "Mod+G" = {
        _props.hotkey-overlay-title = "Open Google...";
        spawn = ["sh" "${./rofi/google.sh}"];
      };
      "Mod+E" = {
        _props.hotkey-overlay-title = "Web search";
        spawn = ["sh" "${./rofi/web-search.sh}"];
      };
      "Mod+P" = {
        _props.hotkey-overlay-title = "Bluetooth connect";
        spawn = ["sh" "${./rofi/bluetooth.sh}"];
      };
      "Mod+Shift+N" = {
        _props.hotkey-overlay-title = "Niri msg";
        spawn = ["sh" "${./rofi/niri-action.sh}"];
      };

      # Utility and help
      "Mod+Comma" = {
        _props.hotkey-overlay-title = "Show hotkeys";
        show-hotkey-overlay = {};
      };
      # Credit for this power-menu script https://github.com/jluttine/rofi-power-menu
      "Mod+Escape" = {
        _props.hotkey-overlay-title = "Quit niri";
        spawn = ["sh" "-c" "rofi -show power-menu -theme-str 'inputbar {enabled: false; } listview {margin: 0 0 0; }' -show-icons -modi power-menu:${./rofi/rofi-power-menu}"];
      };
      "Mod+Q" = {
        _props.hotkey-overlay-title = "Close window";
        close-window = {};
      };

      # Screenshots, screenshot-screen is bronken so doing this until it's fixed
      "Mod+Shift+3" = {
        _props.hotkey-overlay-title = "Screenshot screen";
        spawn = ["niri" "msg" "action" "screenshot-screen"];
      };
      "Mod+Shift+4" = {
        _props.hotkey-overlay-title = "Screenshot region";
        screenshot = [];
      };
      "Mod+Shift+5" = {
        _props.hotkey-overlay-title = "Screenshot window";
        screenshot-window._props = { write-to-disk = false; };
      };

      # Window and column size
      "Mod+TouchpadScrollRight" = {
        # _props.hotkey-overlay-title = "Expand window";
        _props.hotkey-overlay-title = "null";
        set-window-width = "+10";
      };
      "Mod+TouchpadScrollLeft" = {
        # _props.hotkey-overlay-title = "Shrink window";
        _props.hotkey-overlay-title = "null";
        set-window-width = "-10";
      };
      "Mod+TouchpadScrollUp" = {
        # _props.hotkey-overlay-title = "Expand window";
        _props.hotkey-overlay-title = "null";
        set-window-height = "+10";
      };
      "Mod+TouchpadScrollDown" = {
        # _props.hotkey-overlay-title = "Shrink window";
        _props.hotkey-overlay-title = "null";
        set-window-height = "-10";
      };
      "Mod+R" = {
        _props.hotkey-overlay-title = "Switch height";
        switch-preset-window-height = {};
      };
      "Mod+Shift+R" = {
        _props.hotkey-overlay-title = "Reset height";
        reset-window-height = {};
      };
      "Mod+F" = {
        _props.hotkey-overlay-title = "Switch width";
        switch-preset-column-width = {};
      };
      "Mod+Shift+F" = {
        _props.hotkey-overlay-title = "Maximize Column";
        maximize-column = {};
      };
      "Mod+Alt+F" = {
        _props.hotkey-overlay-title = "Fullscreen";
        fullscreen-window = {};
      };

      #Tabs
      "Mod+T" = {
        _props.hotkey-overlay-title = "Switch to tabbed view";
        toggle-column-tabbed-display = {};
      };
      "Mod+Down" = {
        _props.hotkey-overlay-title = "null";
        focus-window-down = {};
      };
      "Mod+Up" = {
        _props.hotkey-overlay-title = "null";
        focus-window-up = {};
      };

      # Window and column movement
      "Mod+Tab" = {
        _props.hotkey-overlay-title = "Focus previous window";
        focus-window-previous = {};
      };
      "Mod+H" = {
        _props.hotkey-overlay-title = "Focus column/window {hjkl}";
        focus-column-left = {};
      };
      "Mod+L" = {
        _props.hotkey-overlay-title = "null";
        focus-column-right = {};
      };
      "Mod+Ctrl+H" = {
        _props.hotkey-overlay-title = "Move column/window {hjkl}";
        move-column-left = {};
      };
      "Mod+Ctrl+L" = {
        _props.hotkey-overlay-title = "null";
        move-column-right = {};
      };
      "Mod+V" = {
        _props.hotkey-overlay-title = "Toggle floating windows";
        toggle-window-floating = {};
      };
      "Mod+Shift+V" = {
        _props.hotkey-overlay-title = "Switch tiling/window focus";
        switch-focus-between-floating-and-tiling = {};
      };
      "Mod+Shift+H" = {
        _props.hotkey-overlay-title = "Consume or expel {hl}";
        consume-or-expel-window-left = {};
      };
      "Mod+Shift+L" = {
        _props.hotkey-overlay-title = "null";
        consume-or-expel-window-right = {};
      };

      # Workspaces
      "Mod+J" = {
        _props.hotkey-overlay-title = "null";
        focus-window-or-workspace-down = {};
      };
      "Mod+K" = {
        _props.hotkey-overlay-title = "null";
        focus-window-or-workspace-up = {};
      };
      "Mod+Shift+J" = {
        _props.hotkey-overlay-title = "Focus workspace {jk}";
        focus-workspace-down = {};
      };
      "Mod+Shift+K" = {
        _props.hotkey-overlay-title = "null";
        focus-workspace-up = {};
      };
      "Mod+Ctrl+J" = {
        _props.hotkey-overlay-title = "Move window or workspace {jk}";
        move-window-down-or-to-workspace-down = {};
      };
      "Mod+Ctrl+K" = {
        # _props.hotkey-overlay-title = "Move window or workspace up";
        _props.hotkey-overlay-title = "null";
        move-window-up-or-to-workspace-up = {};
      };
      "Mod+O" = {
        _props.hotkey-overlay-title = "Toggle overview";
        toggle-overview = {};
      };
      "Mod+1" = {
        _props.hotkey-overlay-title = "Focus workspace 1";
        focus-workspace = "firefox";
      };
      "Mod+2" = {
        _props.hotkey-overlay-title = "Focus workspace 2...";
        focus-workspace = "wezterm";
      };
      "Mod+3" = {
        focus-workspace = "vesktop";
      };
      "Mod+4" = (if settings.steam then {
        focus-workspace = "steam";
      } else {
        focus-workspace = "4";
      });
      "Mod+5" = {
        focus-workspace = "5";
      };
      "Mod+6" = {
        focus-workspace = "6";
      };
      "Mod+7" = {
        focus-workspace = "7";
      };
      "Mod+8" = {
        focus-workspace = "8";
      };
      "Mod+9" = {
        focus-workspace = "9";
      };

      # Monitor movement
      "Mod+Alt+H" = {
        _props.hotkey-overlay-title = "Focus left monitor";
        focus-monitor-left = {};
      };
      "Mod+Alt+L" = {
        _props.hotkey-overlay-title = "Focus right monitor";
        focus-monitor-right = {};
      };
      "Mod+Shift+Tab" = {
        _props.hotkey-overlay-title = "Focus other monitor"; # Assuming two monitors
        focus-monitor-previous = {};
      };
      "Mod+Ctrl+Shift+H" = {
        _props.hotkey-overlay-title = "Move window to left monitor";
        move-window-to-monitor-left = {};
      };
      "Mod+Ctrl+Shift+L" = {
        _props.hotkey-overlay-title = "Move window to right monitor";
        move-window-to-monitor-right = {};
      };
      "Ctrl+Alt+Tab" = {
        _props.hotkey-overlay-title = "Move window to other monitor"; # Assuming two monitors
        move-window-to-monitor-previous = {};
      };

      # Dynamic screen cast
      "Mod+M" = {
        _props.hotkey-overlay-title = "Dynamic cast window";
        set-dynamic-cast-window = {};
      };
      "Mod+Shift+M" = {
        _props.hotkey-overlay-title = "Dynamic cast monitor";
        set-dynamic-cast-monitor = {};
      };
      "Mod+Shift+C" = {
       _props.hotkey-overlay-title = "Clear dynamic cast target";
        clear-dynamic-cast-target = {};
      };

      # Function row
      "XF86MonBrightnessDown".spawn = [ "brightnessctl" "s" "10%-"];
      "XF86MonBrightnessUp".spawn = [ "brightnessctl" "s" "10%+" ];

      "XF86LaunchA".toggle-overview = {};

      "XF86Search" = {
        _props.hotkey-overlay-title = "Do not disturb";
        spawn = ["sh" "${./dnd.sh}"];
      };

      "XF86AudioMicMute" = {
        _props.hotkey-overlay-title = "Random wallpaper";
        spawn = ["systemctl" "--user" "start" "wallpaper.service"];
      };
      "XF86Sleep".spawn = ["sh" "-c" "niri msg action do-screen-transition && swaylock"];

      "XF86AudioPrev".spawn = ["playerctl" "previous"];
      "XF86AudioPlay".spawn = ["playerctl" "play-pause"];
      "XF86AudioNext".spawn = ["playerctl" "next"];

      "XF86AudioMute".spawn = ["wpctl" "set-mute" "@DEFAULT_SINK@" "toggle"];
      "XF86AudioLowerVolume".spawn = ["wpctl" "set-volume" "@DEFAULT_SINK@" "5%-"];
      "XF86AudioRaiseVolume".spawn = ["wpctl" "set-volume" "@DEFAULT_SINK@" "5%+"];
    };

    switch-events = with config.lib.niri.actions; {
      "lid-close" = {
        spawn = ["sh" "-c" "niri msg action do-screen-transition && swaylock"];
      };
    };

    environment.DISPLAY = XWAYLAND_DISPLAY;

    prefer-no-csd = true;

    _children = [
      { 
        output = { _args = ["eDP-1"]; scale = 1.5; };
      } 

      # Spawn at startup
      { spawn-at-startup._args = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" XWAYLAND_DISPLAY ]; }
      # { command = [ "${x-wayland-clipboard-daemon}" ]; }
      { spawn-at-startup._args = [ "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" ]; } # needed for screen-sharing to work
      { spawn-at-startup._args = [ "systemctl" "--user" "start" "background" "nm-applet" ]; }
      { spawn-at-startup._args = [ "awww-daemon" ]; }
      { spawn-at-startup._args = [ "niriswitcher"]; }

      { spawn-at-startup._args = [ "vesktop" "--ozone-platform-hint=wayland" ]; }
      { spawn-at-startup._args = [ "wezterm" ]; }
      { spawn-at-startup._args = [ "firefox" ]; }

      # Workspaces!! 
      { workspace._args = [ "firefox" ]; }
      { workspace._args = [ "wezterm" ]; }
      { workspace._args = [ "vesktop" ]; }
      
      # Layer rules!!
      { 
        layer-rule._children = [
          {
            match._props = { namespace = ''^awww-daemon$''; };
            place-within-backdrop = true;
          }
        ]; 
      }
      { 
        layer-rule._children = [
          {
            match._props = { namespace = "^notifications$"; };
            block-out-from = "screencast";
          }
        ]; 
      }
      {
        layer-rule._children = [
          {
            _children = [
              { 
                match._props = {
                  layer = "overlay"; 
                };
              } 
            ];
            background-effect = { blur = true; };
            geometry-corner-radius = 24;
          }
        ];
      }
      # Window rules!!
      {
        window-rule._children = [ {
          default-column-width.proportion = 0.5;
          draw-border-with-background = false;
          geometry-corner-radius._args = 
          let
            rad = 10.0;
          in 
            [
                rad
                rad
                rad
                rad
            ];
          clip-to-geometry = true;
        } ];
      }
      {
        window-rule._children = [
          {
            exclude._props = { title = ''- YouTube — Mozilla Firefox$''; };
          }
          {
            exclude._props = { title = ''- Twitch — Mozilla Firefox$''; };
          }
          {
            exclude._props = { app-id = ''^darktable$''; };
          }
        ];
      }
      {
        window-rule._children = [ {
          match._props = { is-window-cast-target = true; };
          focus-ring = {
            active-color = "#f38ba8";
            inactive-color = "#7d0d2d";
          };
          border = {
            on = {};
            width = 1;
            inactive-color = "#7d0d2d80";
          };
          shadow = {
            color = "#7d0d2d70";
          };
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { app-id = "org.pulseaudio.pavucontrol"; };
          open-floating = true;
          default-window-height.proportion = 0.4;
          default-floating-position._props = {
            relative-to = "top-right";
            x = 20.0;
            y = 10.0;
          };
        } ];
      }
      {
        window-rule._children = [ {
          # Sorry alacritty nerds but i dont use this terminal
          match._props = { app-id = "Alacritty"; };
          open-floating = true;
          default-window-height.proportion = 0.3;
          default-column-width.proportion = 0.4;
          focus-ring = {
            width = 2;
            active-color = "#${theme.current.accent2}";
          };
          default-floating-position._props = {
            relative-to = "top-right";
            x = 20.0;
            y = 10.0;
          };
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { app-id = "app.liten.Gram"; };
          default-window-height.proportion = 1.0;
          default-column-width.proportion = 1.0;
          background-effect = { blur = true; };
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { app-id = "org.wezfurlong.wezterm"; };
          default-window-height.proportion = 1.0;
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { app-id = "Bitwarden"; };
          open-floating = true;
          default-window-height.proportion = 0.8;
          default-column-width.proportion = 0.5;
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { at-startup = true; app-id = "firefox"; };
          open-on-workspace = "firefox";
          default-column-width.proportion = 1.0;
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { at-startup = true; app-id = "org.wezfurlong.wezterm"; };
          open-on-workspace = "wezterm";
          default-column-width.proportion = 1.0;
        } ];
      }
      {
        window-rule._children = [ {
          match._props = { at-startup = true; app-id = "vesktop"; };
          open-on-workspace = "vesktop";
          default-column-width.proportion = 1.0;
        } ];
      }
      {
        window-rule._children = [ {
        match._props = { app-id="^rofi$"; };
        draw-border-with-background = false;
        background-effect = {
            blur = true;
        };
      }
      ];
      }
    ];

    overview = {
      workspace-shadow = {};
      zoom = 0.5;
    };

    layout = {
      background-color = "transparent";
      gaps = 16;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
      focus-ring = {
        on = {};
        width = 3;
        active-gradient._props = {
          from = "#${theme.current.accent2}";
          to = "#${theme.current.accent}";
          angle = 0;
          "in" = "srgb";
          relative-to = "workspace-view";
        };
        inactive-gradient._props = {
          from = "#${theme.current.accent2}60";
          to = "#${theme.current.accent}60";
          angle = 0;
          "in" = "srgb";
          relative-to = "workspace-view";
        };
      };
      shadow = {
        on = {};
        color = "#00000071";
      };
      tab-indicator = {
        on = {};
        width = 5.0;
        gap = 4.0;
      };
    };
  } // (if settings.steam then {
    workspaces."4".name = "steam";
    window-rules = [
      {
        matches = [ { app-id = "gamescope"; } ];
        open-on-workspace = "steam";
        default-column-width.proportion = 1.0;
        opacity = 1.0;
      }
    ];
  } else {} );

  xdg.configFile."niriswitcher/config.toml".text = ''
    separate_workspaces = false
  '';
  xdg.configFile."niriswitcher/style.css".text = ''
    .application-title {
      color: #${theme.current.text1};
    }

    :root {
      --bg-color: #${theme.current.base2};
      --border-color: #${theme.current.accent};
    }
  '';

  # Random desktop wallpaper service
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Random Desktop Wallpaper";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${random-wallpaper}";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.wallpaper = {
    Timer = {
      Unit = "wallpaper";
      OnUnitActiveSec = "0.5h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
