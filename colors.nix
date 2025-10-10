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
    sddm         = "${./resources/sddm/macchiatoqt5}";
  };
  gruvbox = rec {
    name         = "Gruvbox Dark (Yellow accent)";
    accent       = light-yellow;
    accent2      = yellow;
    red          = "cc241d"; # dark-red-dark
    green        = "98971a"; # dark-green-dark
    yellow       = "d79921"; # dark-yellow-dark
    blue         = "458588"; # dark-blue-dark
    purple       = "b16286"; # dark-purple-dark
    orange       = "d65d0e"; # dark-orange-dark
    teal         = "689d6a"; # dark-aqua-dark
    cyan         = "8ec07c"; # dark-aqua-light
    light-red    = "fb4934"; # dark-red-light
    light-green  = "b8bb26"; # dark-green-light
    light-yellow = "fabd2f"; # dark-yellow-light
    light-blue   = "83a598"; # dark-blue-light
    light-purple = "d3869b"; # dark-purple-light
    pink         = light-purple; # dark-purple-light
    light-orange = "d65d0e"; # dark-orange-light
    text1        = "ebdbb2"; # fg1
    text2        = "d5c4a1"; # fg2
    text3        = "bdae93"; # fg3
    overlay2     = "fbf1c7"; # fg0
    overlay1     = "928374"; # gray
    overlay0     = "7c6f64"; # bg4
    surface2     = "665c54"; # bg3
    surface1     = "504945"; # bg2
    surface0     = "3c3836"; # bg1
    base1        = "282828"; # bg0
    base2        = "1d2021"; # bg0_h
    base3        = base2; # bg0_h

    wallpapers   = "${./gruvbox-wallpapers}";
    discordcss   = "${./resources/vesktop/gruvbox-dark.theme.css}";
    yazi         = "${./resources/yazi/gruvbox}";
    wezterm      = ''config.color_scheme = "Gruvbox Dark (Gogh)"'';
    nvim         = ''vim.cmd("colorscheme gruvbox")'';
    bat          = "gruvbox-dark";
    sddm         = "${./resources/sddm/gruvboxqt5}";
  };
}
