{ theme, ... }:
{ 
  programs.vesktop = {
    enable = true;
    vencord = {
      themes = {
        cur = theme.current.discordcss;
      };
      settings = {
        enabledThemes = [
          "cur.css"
        ];
      };
    };
  };

}
