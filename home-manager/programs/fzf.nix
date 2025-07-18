{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--border"
    ];
    colors = {
      "bg+" = "#363A4F";
      bg = "#24273A";
      spinner = "#F4DBD6";
      hl = "#ED8796";
      fg = "#CAD3F5";
      header = "#ED8796";
      info = "#C6A0F6";
      pointer = "#F4DBD6";
      marker = "#B7BDF8";
      "fg+" = "#CAD3F5";
      prompt = "#C6A0F6";
      "hl+" = "#ED8796";
      selected-bg = "#494D64";
      border = "#363A4F";
      label = "#CAD3F5";
    };
  };
}
