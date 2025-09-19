{ theme, ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    theme = {
      filekinds = {
        directory.foreground = "#${theme.current.accent}";
        symlink.foreground = "#${theme.current.teal}";
      };
    };
  };
}
