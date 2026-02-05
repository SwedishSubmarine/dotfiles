rec {
  current = gruvbox;

  macchiato = rec {
    accent       = purple;
    accent2      = pink;
    # rosewater = "f4dbd6";
    # flamingo  = "f0c6c6";
    name         = "Catppuccin Macchiato";
    pink         = "f5bde6"; # Pink
    purple       = "c6a0f6"; # Mauve
    red          = "ed8796"; # Red
    # maroon      = "ee99a0";
    orange       = "f5a97f"; # Peach
    yellow       = "eed49f"; # Yellow
    green        = "a6da95"; # Green
    teal         = "8bd5ca"; # Teal
    light-blue   = "91d7e3"; # Sky
    cyan         = "7dc4e4"; # Sapphire
    blue         = "8aadf4"; # Blue
    light-purple = "b7bdf8"; # Lavender
    text1        = "cad3f5"; # Text
    text2        = "b8c0e0"; # Subtext1
    text3        = "a5adcb"; # Subtext0
    overlay2     = "939ab7";
    overlay1     = "8087a2";
    overlay0     = "6e738d";
    surface2     = "5b6078";
    surface1     = "494d64";
    surface0     = "363a4f";
    base1        = "24273a"; # Base
    base2        = "1e2030"; # Mantle
    base3        = "181926"; # Crust

    wallpapers   = "${./catppuccin-wallpapers}";
    discordcss   = "${./resources/vesktop/macchiatto.css}";
    yazi         = "${./resources/yazi/macchiato}";
    wezterm      = ''config.color_scheme = "Catppuccin Macchiato"'';
    nvim         = ''vim.cmd("colorscheme catppuccin-macchiato")'';
    bat          = "Catppuccin Macchiato";
  };
  gruvbox = rec {
    name         = "Gruvbox Dark (Yellow accent)";
    accent       = light-yellow;
    accent2      = yellow;
    red          = "cc241d"; # dark-red-dark #cc241d
    green        = "98971a"; # dark-green-dark #98971a
    yellow       = "d79921"; # dark-yellow-dark #d79921
    blue         = "458588"; # dark-blue-dark #458588
    purple       = "b16286"; # dark-purple-dark #b16286
    orange       = "d65d0e"; # dark-orange-dark #d65d0e
    teal         = "689d6a"; # dark-aqua-dark #689d6a
    cyan         = "8ec07c"; # dark-aqua-light #8ec07c
    light-red    = "fb4934"; # dark-red-light #fb4934
    light-green  = "b8bb26"; # dark-green-light #b8bb26
    light-yellow = "fabd2f"; # dark-yellow-light #fabd2f
    light-blue   = "83a598"; # dark-blue-light #83a598
    light-purple = "d3869b"; # dark-purple-light #d3869b
    pink         = light-purple; # dark-purple-light
    light-orange = "d65d0e"; # dark-orange-light #d65d0e
    text1        = "ebdbb2"; # fg1 #ebdbb2
    text2        = "d5c4a1"; # fg2 #d5c4a1
    text3        = "bdae93"; # fg3 #bdae93
    overlay2     = "fbf1c7"; # fg0 #fbf1c7
    overlay1     = "928374"; # gray #928374
    overlay0     = "7c6f64"; # bg4 #7c6f64
    surface2     = "665c54"; # bg3 #665c54
    surface1     = "504945"; # bg2 #504945
    surface0     = "3c3836"; # bg1 #3c3836
    base1        = "282828"; # bg0 #282828
    base2        = "1d2021"; # bg0_h #1d2021
    base3        = base2; # bg0_h

    wallpapers   = "${./gruvbox-wallpapers}";
    discordcss   = "${./resources/vesktop/gruvbox-dark.theme.css}";
    yazi         = "${./resources/yazi/gruvbox}";
    wezterm      = ''config.color_scheme = "Gruvbox Dark (Gogh)"'';
    nvim         = ''vim.cmd("colorscheme gruvbox")'';
    bat          = "gruvbox-dark";
  };
}
