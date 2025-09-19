{ theme, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = (if theme.current.name=="gruvbox" then 
      "gruvbox-dark" 
      else if theme.current.name=="macchiato" then 
      "Catpuccin Macchiato" else "");
    };
  };

}
