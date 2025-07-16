{  config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "emily.jo.tiberg@gmail.com";
    userName = "Emily Tiberg";
    aliases = {
      s = "status";
    };
    ignores = ["**/.DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      merge.autostash = true;
    };
  };
}
