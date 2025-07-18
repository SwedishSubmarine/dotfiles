{ ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      sub-auto = "fuzzy";
      hwdec = "auto";
      volume-max = 150;
      ytdl-format = "bestvideo[height<=?1080][vcodec!~='av1']+bestaudio";
    };
  };

  catppuccin.mpv = {
    enable = true;
  };
}
