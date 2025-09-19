{ theme, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = theme.current.bat;
    };
  };

}
