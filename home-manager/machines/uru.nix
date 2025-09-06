{ pkgs, ... }:
{
  home = {
    username = "emily";
    homeDirectory = "/home/emily";
    stateVersion = "25.05";

    packages = with pkgs; [
      # Terminal applications
      wget
      yt-dlp
      ffmpeg
      resvg
      ripgrep
    ];
  };

  imports = [
    ../terminal-core/terminal.nix
  ];
}
