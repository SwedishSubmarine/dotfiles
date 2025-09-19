{ pkgs, theme, settings, ... }:
let 
  yazi-plugins = pkgs.fetchFromGitHub {
		owner = "yazi-rs";
		repo = "plugins";
		rev = "b8860253fc44e500edeb7a09db648a829084facd";
		hash = "sha256-29K8PmBoqAMcQhDIfOVnbJt2FU4BR6k23Es9CqyEloo=";
	};
in
{
  programs.yazi = {
    enable = true;
    # package = yazi.packages.${pkgs.system}.default;
    enableZshIntegration = true;
    shellWrapperName = "y";
    flavors = {
      gruvbox = "${../../resources/yazi/gruvbox}";
      macchiato = "${../../resources/yazi/macchiato}";
    };
    theme = {
      flavor = {
        dark = (if theme.current.name=="gruvbox" then "gruvbox" 
        else if theme.current.name=="macchiato" then "macchiato" else "");
      };
    };
    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        title_format = "{cwd}";
      };
      preview = {
        wrap = "no";
        max_width = 3840;
        max_height = 2160;
      };
      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };
    plugins = {
      smart-enter = "${yazi-plugins}/smart-enter.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      git = "${yazi-plugins}/git.yazi";
      mount = "${yazi-plugins}/mount.yazi";
      chmod = "${yazi-plugins}/chmod.yazi";
      zoom = "${yazi-plugins}/zoom.yazi";
      toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
    };
    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
    '';
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "+";
          run = "plugin zoom 1";
          desc = "Zoom in hovered file";
        }
        {
          on = "-";
          run = "plugin zoom -1";
          desc = "Zoom out hovered file";
        }
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter child directory or open file";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore preview";
        }
        {
          on = "M";
          run = "plugin mount";
        }
        { 
          on = "f";
          run = "plugin fzf";
        }
        {
          on = "z";
          run = "plugin zoxide";
        }
      ];
    };
  };
}
