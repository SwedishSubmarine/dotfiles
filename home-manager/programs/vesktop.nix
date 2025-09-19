{ theme, ... }:
{ 
  programs.vesktop = {
    enable = true;
    vencord = {
      settings = {
        enabledThemes = if theme.current.name=="gruvbox" then [
          "gruvbox-dark.theme.css" 
        ] else if theme.current.name=="macchiato" then [
          "macchiatto.css"
        ] else [];
      };
    };
  };

}
