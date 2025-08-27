{ unstable, theme, ... }:
{
  programs.rofi = {
    enable = true;
    package = unstable.rofi-wayland;
    theme = "~/.config/rofi/rounded.rasi";
    extraConfig = {
      matching = "fuzzy";
      kb-row-down = "Control+j,Control+p,Down";
      kb-row-up = "Control+k,Control+n,Up";
      kb-accept-entry = "Control+m,Return,KP_Enter";
      kb-remove-to-eol = "Control+Shift+d";
      kb-remove-to-sol = "Control+d";
      kb-remove-char-forward = "Delete";
      kb-secondary-copy = "";
    };
  };

  # Config for bitwarden rofi thingy
  xdg.configFile."rofi-rbw.rc".text = ''
    keybindings alt+1:type:username:tab:password,alt+2:type:username,alt+3:type:password,ctrl+c:copy:password,ctrl+u:copy:username,alt+m:type:menu,alt+s:sync
    menu-keybindings ctrl+c:copy,ctrl+t:type
  '';
  
  xdg.configFile."rofi/rounded.rasi".text = ''
    * {
        // font:  "Hack 12";
        font:   "MonaspiceRn Nerd Font 12";
        background-color:   transparent;
        text-color:         #${theme.current.text1};
        margin:     0px;
        padding:    0px;
        spacing:    0px;
    }
    window {
        location:       north;
        y-offset:       calc(50% - 234px);
        width:          800;
        border-radius:  24px;
        border: 2px;
        background-color:  #${theme.current.base2};
        border-color: #${theme.current.accent};
    }

    mainbox {
        padding:    12px;
    }

    inputbar {
        background-color:   #${theme.current.base1};
        border-color:       #${theme.current.accent};
        border:         1px;
        border-radius:  16px;
        padding:    8px 16px;
        spacing:    8px;
        children:   [ prompt, entry ];
    }

    prompt {
        text-color: #${theme.current.text2};
    }

    entry {
        placeholder:        "Search";
        placeholder-color:  #${theme.current.overlay1};
    }

    message {
        margin:             12px 0 0;
        border-radius:      16px;
        border-color:       #${theme.current.accent};
        background-color:   #${theme.current.surface1};
    }

    textbox {
        padding:    8px 24px;
    }

    listview {
        background-color:   transparent;
        margin:     12px 0 0;
        lines:      12;
        columns:    1;
        fixed-height: false;
    }

    element {
        padding:        8px 16px;
        spacing:        8px;
        border-radius:  16px;
    }

    element normal active {
        text-color: #${theme.current.accent};
    }

    element alternate active {
        text-color: #${theme.current.accent};
    }

    element selected normal, element selected active {
        background-color:   #${theme.current.base3};
        border: 1px;
        border-color: #${theme.current.accent};
    }

    element-icon {
        size:           1em;
        vertical-align: 0.5;
    }

    element-text {
        text-color: inherit;
    }
  '';
}
