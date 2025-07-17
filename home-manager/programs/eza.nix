{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    theme = {
      filekinds = {
        directory.foreground = "#c6a0f6";
        symlink.foreground = "#8bd5ca";
      };
    };
  };
}
