{ ... }:
{
  programs.git = {
    enable = true;
    ignores = ["**/.DS_Store" ];
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      core.symlinks = true;
      merge.autostash = true;
      user.Email = "emily.jo.tiberg@gmail.com";
      user.Name = "Emily Tiberg";
      alias = {
        s = "status";
        lg = ''log --oneline --graph --decorate --pretty=format:"%C(cyan)%h\ %ad%Cred%d \%Creset%s%Cblue" --date=short'';
    };
    };
  };
}
