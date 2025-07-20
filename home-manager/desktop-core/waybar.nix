{   config, pkgs, ... }: {
  systemd.user.services.nm-applet = {
    Unit = {
      Description = "Network manager applet";
    };
    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };
  };

  # Going to add more stuff to waybar:
  # Probably not workspaces
  # Power profiles daemon
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
        "clock"
      ];
      "group/left" = {
        orientation = "horizontal";
        modules = [
          "custom/power"
          "tray"
          "battery"
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
      "power-profiles-daemon" = {
        format = "{icon}";
        format-icons = {
          default = " ";
          balanced = " ";
          power-saver = " ";
        };
        tooltip = false;
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
        on-click = "pavucontrol";
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
      };
      "custom/power" = {
        format = "⏻ ";
        tooltip = false;
        on-click = "rofi -show power-menu -show-icons -modi power-menu:${./rofi/rofi-power-menu}";
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
      @define-color   rose     #f4dbd6;
      @define-color   flamingo #f0c6c6;
      @define-color   pink     #f5bde6;
      @define-color   mauve    #c6a0f6;
      @define-color   lavender #b7bdf8;
      @define-color   red      #ed8796;
      @define-color   maroon   #ee99a0;
      @define-color   peach    #f5a97f;
      @define-color   yellow   #eed49f;
      @define-color   blue     #8aadf4;
      @define-color   sapphire #7dc4e4;
      @define-color   sky      #91d7e3;
      @define-color   teal     #8bd5ca;
      @define-color   green    #a6da95;

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

      menu {
          background-color: alpha(@mantle,.6);
          color: @text;
          border: 2px solid @mauve
      }

      menu :disabled {
          color: rgba(95, 91, 92, 1);
      }

      #left {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 0px 0px 12px;
          background: alpha(@mantle,.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border-radius:10px;
          border: 3px solid @mauve;
      }

      #window {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 0px 0px 5px;
          background: alpha(@mantle,.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border-radius:10px;
          border: 3px solid @mauve;
      }

      window#waybar.empty #window {
        opacity: 0;
      }

      window#waybar {
        background-color: rgba(0,0,0,0);
        color: @text;
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
          background: alpha(@mantle,.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
      }
      */

      #mpris {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 5px 0px 5px;
          border-radius:10px;
          background: alpha(@mantle,.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
          color: @teal;
      }

      .modules-right {
          padding-left: 10px;
          padding-right: 10px;
          margin:10px 12px 0px 0px;
          border-radius:10px;
          background: alpha(@mantle,.7);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
          border: 3px solid @mauve;
      }

      #pulseaudio {
        padding-left: 10px;
        padding-right: 5px;
        color: @yellow;
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
          color: @text;
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

      #backlight {
        padding-left: 10px;
        padding-right: 10px;
        color: @yellow;
      }

      #backlight-slider {
          padding-left: 0px;
          padding-right: 0px;
          min-width: 100px;
          color: @text;
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
          min-height: 15px;
          min-width: 10px;
          border-radius: 5px;
          background-color: @crust;
      }
      #backlight-slider highlight {
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

      #tray {
          padding-left: 5px;
          padding-right: 10px;
      }

      #battery {
          padding-left: 0px;
          padding-right: 10px;
      }

      #battery.warning {
         color:       @peach; 
      }

      #battery.critical {
          color:      @red;
      }
      
      #custom-power {
          color:      @mauve;
          padding-left: 0px;
          padding-right: 0px;
      }

      #network {
          padding-left: 20px;
          padding-right: 10px;
          color: @sky;
      }

      #bluetooth {
          padding-left: 10px;
          padding-right: 10px;
          color: @blue;
      }

      #clock {
          padding-left: 10px;
          padding-right: 10px;
          color: @text;
      }

      #power-profiles-daemon {
          padding-left: 10px;
          padding-right: 0px;
      }

      #power-profiles-daemon.balanced {
          color: @yellow;
      }

      #power-profiles-daemon.power-saver {
          color: @green;
      }
    '';
  };
}
