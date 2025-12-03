{ pkgs, theme, config, ... }: 
let  
  poll-dnd = pkgs.writeScript "poll-dnd" ''
    #!/bin/sh

    statefile="${config.home.homeDirectory}/.cache/dnd_state"

    if [[ -f "${config.home.homeDirectory}/.cache/dnd_state" ]] ; then
      state=$(cat "$statefile")
    else 
      state="unmuted"
    fi

    if [[ "$state" == "unmuted" ]] ; then
      icon="󰂚"
    else
      icon="󰂛"
    fi

    printf '{"text": "%s ", "tooltip": "Do not disturb"}' $icon
  '';
in 
{
  systemd.user.services.nm-applet = {
    Unit = {
      Description = "Network manager applet";
    };
    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.service";
    };

    settings.mainBar = {
      height = 40;

      layer = "top";
      modules-left = [
        "group/left"
        "niri/window"
      ];
      modules-center = [
        "mpris"
      ];
      modules-right = [
        "backlight"
        "backlight/slider"
        "pulseaudio" "pulseaudio/slider"
        "network"
        "bluetooth"
        "power-profiles-daemon"
        "custom/dnd"
        "clock"
      ];
      "group/left" = {
        orientation = "horizontal";
        modules = [
          "custom/power"
          "tray"
          "battery"
          "niri/workspaces"
        ];
      };
      "niri/window" = {
        icon = true;
        icon-size = 24;
        max-length = 40;
        rewrite = {
          "(.*) (?:— Mozilla (Firefox|Thunderbird)|- Quod Libet)" = "$1"; # remove some titles
          "(Mozilla Firefox)" = "$1";
          "(Discord \\| .*)" = "$1";
          "• Discord \\| ([^|]*) \\| (.*)" = "$2 ⟩ $1"; # discord formats things as Discord | Channel | Server
          "• Discord \\| ([^|]*)" = "$1"; # sometimes there's no server to show
          # pinged versions
          "\\((\\d+)\\) Discord \\| ([^|]*) \\| (.*)"  ="$3 ⟩ $2 ($1)";
          "\\((\\d+)\\) Discord \\| ([^|]*)" = "$2 ($1)";
          "(.* TIDAL)" = " $1 ";
          " " = "";
        };
      };
      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };
      "power-profiles-daemon" = {
        format = "{icon}";
        format-icons = {
          default = " ";
          balanced = " ";
          power-saver = " ";
        };
        tooltip = "Power profile";
      };
      backlight = {
        format = "󰛨 ";
        format-alt = "󱧣 {percent}%";
        format-alt-click = "click-right";
        tooltip = false;
        #change padding
      };
      pulseaudio = {
        format = "{icon}";
        format-alt = "{volume} {icon}";
        format-alt-click = "click-right";
        format-muted = "🔇";
        format-icons = {
            default = [" " " " " "];
        };
        scroll-step = 1;
        on-click = "pkill .pavucontrol-wr || pavucontrol";
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
        on-click = "pkill alacritty || alacritty -e nmtui";
        tooltip = "Nmtui wi-fi";
      };
      bluetooth = {
        on-click = "pkill blueberry || blueberry";
        format = "";
        tooltip = "Blueberry";
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
      };
      "custom/power" = {
        format = "⏻ ";
        tooltip = false;
        on-click = "rofi -show power-menu -show-icons -modi power-menu:${./rofi/rofi-power-menu}";
      };
      "custom/dnd" = {
        format = "{}";
        exec = "${poll-dnd}";
        interval = 1;
        return-type = "json";
        on-click = "${./dnd.sh}";
      };
      mpris = {
        title-len = 30;
        interval = 1;
        album-len = 0;
        max-len = 50;
        max-empty-time = 60;
        format = "{player_icon} {artist} - {title}";
        format-paused = " {artist} - {title}";
        player-icons = {
          default = " ";
        };
        status-icons = {
          paused = "";
        };
        ignored-players = [
          "firefox"
        ];
      };
    };
    style = ''
      * {
          font-size:18px;
          font-family: "Hack Nerd Font";
      }
      menu {
          background-color: alpha(#${theme.current.base2},.6);
          color: #${theme.current.text1};
          border: 2px solid #${theme.current.accent};
      }

      menu :disabled {
          color: rgba(95, 91, 92, 1); 
      }

      #left {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 0px 0px 12px;
          background: alpha(#${theme.current.base2},.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border-radius:10px;
          border: 3px solid #${theme.current.accent};
      }

      #window {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 0px 0px 5px;
          background: alpha(#${theme.current.base2},.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border-radius:10px;
          border: 3px solid #${theme.current.accent};
      }

      window#waybar.empty #window {
        opacity: 0;
      }

      window#waybar {
        background-color: rgba(0,0,0,0);
        color: #${theme.current.text1};
      }

      window#waybar.hidden {
        opacity: 0.2;
      }
      /*
      .modules-center {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 0px 0px 0px;
          border-radius:10px;
          background: alpha(#${theme.current.base2},.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid #${theme.current.accent};
      }
      */

      #mpris {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 5px 0px 5px;
          border-radius:10px;
          background: alpha(#${theme.current.base2},.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid #${theme.current.accent};
          color: #${theme.current.teal};
      }

      .modules-right {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 12px 0px 0px;
          border-radius:10px;
          background: alpha(#${theme.current.base2},.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid #${theme.current.accent};
      }

      #pulseaudio {
        padding-left: 10px;
        padding-right: 5px;
        color: #${theme.current.yellow};
      }

      #pulseaudio-slider {
          min-width: 100px;
          padding-left: 0px;
          padding-right: 0px;
      }

      /* don't show the grabbable thing in the slider */
      #pulseaudio-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
          color: #${theme.current.text1};
      }

      #pulseaudio-slider trough {
          min-height: 15px;
          min-width: 10px;
          border-radius: 5px;
          background-color: #${theme.current.base3};
      }
      #pulseaudio-slider highlight {
          min-width: 10px;
          border-radius: 5px;
          background-color: rgba(247, 246, 246, 1);
      }

      #backlight {
        padding-left: 10px;
        padding-right: 10px;
        color: #${theme.current.yellow};
      }

      #backlight-slider {
          padding-left: 0px;
          padding-right: 0px;
          min-width: 100px;
          color: #${theme.current.text1};
      }

      /* don't show the grabbable thing in the slider */
      #backlight-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
      }

      #backlight-slider trough {
          min-height:     15px;
          min-width:      10px;
          border-radius:  5px;
          background-color: #${theme.current.base3};
      }
      #backlight-slider highlight {
          min-width:      10px;
          border-radius:  5px;
          background-color: rgba(247, 246, 246, 1);
      }
      * {
          border:         none;
          border-radius:  0;
          box-shadow:     none;
          text-shadow:    none;
          transition-duration: 0s;
      }

      #workspaces {
          padding-right:  0px;
      }

      #workspaces button {
          color:      #${theme.current.text1};
          padding-left:   7px;
          padding-right:  7px;
      }
      
      #workspaces button.empty {
          color:          alpha(#${theme.current.text1},.5);
      }

      #workspaces button.active {
          color:          #${theme.current.accent};
      }
      #workspaces button:hover {
          color:          #${theme.current.red};
          background:     inherit; 
      }

      #tray {
          padding-left:   5px;
          padding-right:  5px;
          background:     alpha(#${theme.current.text1},.6);
          border-radius:  20px;
          margin:         3px;
      }

      #battery {
          padding-left:   5px;
          padding-right:  10px;
      }

      #battery.warning {
         color:       #${theme.current.orange}; 
      }

      #battery.critical {
          color:      #${theme.current.red};
      }
      
      #custom-power {
          color:      #${theme.current.accent};
          padding-left: 0px;
          padding-right: 0px;
      }


      #network {
          padding-left: 20px;
          padding-right: 10px;
          color: #${theme.current.light-blue};
      }

      #bluetooth {
          padding-left: 10px;
          padding-right: 10px;
          color: #${theme.current.blue};
      }

      #clock {
          padding-left: 10px;
          padding-right: 10px;
          color: #${theme.current.text1};
      }

      #custom-dnd {
          color:    #${theme.current.light-yellow};
          padding-left: 10px; 
          padding-right: 0px;
      }

      #power-profiles-daemon {
          padding-left: 10px;
          padding-right: 0px;
      }

      #power-profiles-daemon.balanced {
          color: #${theme.current.yellow};
      }

      #power-profiles-daemon.power-saver {
          color: #${theme.current.green};
      }
    '';
  };
}
