{ theme, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--border"
    ];
    colors = {
      "bg+" = "#${theme.current.surface0}";
      bg = "#${theme.current.base1}";
      spinner = "#${theme.current.accent}";
      hl = "#${theme.current.red}";
      fg = "#${theme.current.text1}";
      header = "#${theme.current.red}";
      info = "#${theme.current.accent}";
      pointer = "#${theme.current.accent2}";
      marker = "#${theme.current.light-purple}";
      "fg+" = "#${theme.current.text1}";
      prompt = "#${theme.current.accent}";
      "hl+" = "#${theme.current.red}";
      selected-bg = "#${theme.current.surface1}";
      border = "#${theme.current.surface0}";
      label = "#${theme.current.text1}";
    };
  };
}
