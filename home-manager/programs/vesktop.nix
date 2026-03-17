{ stable, theme, ... }:
{ 
  programs.vesktop = {
    enable = true;
    package = stable.vesktop;
    vencord = {
      themes = {
        cur = theme.current.discordcss;
      };
      settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        enabledThemes = [
          "cur.css"
        ];
        plugins = {
          BetterFolders = {
            enabled = true;
            sidebar = true;
            sidebarAnim = true;
          };
          BetterGifAltText = {
            enabled = true;
          };
          CallTimer = {
            enabled = true; 
          };
          CrashHandler = {
            enabled = true;
          };
          CustomRPC = {
            enabled = true;
          };
          ImageFilename = {
            enabled = true;
          };
          MemberCount = {
            enabled = true;
          };
          NoF1 = {
            enabled = true;
          };
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          petpet = {
            enabled = true;
          };
          settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          WebKeybinds = {
            enabled = true;
          };
          WebScreenShareFixes = {
            enabled = true;
          };
          YoutubeAdblock = {
            enabled = true;
          };
          VolumeBooster = {
            enabled = true;
          };
        };
      };
    };
  };

}
