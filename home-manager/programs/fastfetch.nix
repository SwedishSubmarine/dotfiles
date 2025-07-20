{...}: 
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        color."1" = "#c6a0f6";
        color."2" = "#f5bde6";
        type = "auto";
        source = "nixos";
      };
      display = {
        color = {
          title = "#c6a0f6";
        };
      };
      modules = [
        {
          type = "Title";
          format = "{#1;38;2;255;97;142}E{#1;38;2;255;109;138}m{#1;38;2;255;121;135}j{#1;38;2;255;132;134}a{#1;38;2;255;143;134}u{#1;38;2;255;153;136}l{#1;38;2;253;164;139}y {#1;38;2;252;173;143}^{#1;38;2;250;183;149}_{#1;38;2;248;192;156}^";
        }
        {
          type = "title";
          format = "{6}{##c6a0f6}@{8}";
        }
        "separator"
        "os"
        "host"
        {
          key = "Display";
          type = "display";
          format = "{1}x{2} ({4}x{5}) @ {3}Hz";
        }
        "datetime"
        "shell"
        "wm"
        {
          key = "Theme";
          type = "title";
          format = "Catppuccin Macchiato (Mauve)";
        }
        {
          key = "Terminal";
          type = "terminal";
          format = "{5}";
        }
        {
          key = "Terminal font";
          type = "title";
          format = "Monaspice (Radon)";
        }
        "cpu"
        "gpu"
        "memory"
        {
          key = "Disk";
          type = "disk";
          format = "{1} / {2} ({3})";
        }
        "packages"
        "localip"
        "colors"
      ];
    };
  };
}
