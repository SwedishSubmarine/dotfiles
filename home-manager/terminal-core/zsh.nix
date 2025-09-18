{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    dotDir = "dotfiles/home-manager/terminal-core/zsh";
    history = {
      path = "$ZDOTDIR/.zsh_history";
      save = 100000000000;
      size = 100000000000;
      extended = true;
      share = true;
    };
    shellAliases = {
      ls  = "${pkgs.eza}/bin/eza --icons --color -A";
      lsl = "${pkgs.eza}/bin/eza --icons --color -Al --git-repos --git";
      lst = "${pkgs.eza}/bin/eza --icons --color -A --tree --level=3";
      carfetch = "${pkgs.fastfetch}/bin/fastfetch --logo ~/car.webp --logo-type iterm --logo-width 42";
    };
    # Previously plugins (PP 🐈)
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    completionInit = ''
      autoload -Uz compinit && compinit
      compinit -d "$ZDOTDIR/zcompdump"
    '';
    initContent = ''
      # Various options 
      setopt AUTO_CD
      setopt AUTO_MENU
      setopt globdots
      setopt transientrprompt
      setopt prompt_subst

      source ${../../secrets/dHack.zsh}
      
      function startup_fetch(){
        local columns=$(tput cols)
        local lines=$(tput lines)
        
        local min_columns=80
        local min_lines=24

        if (( columns >= min_columns && lines >= min_lines )); then
          command -v fastfetch &> /dev/null && fastfetch
        fi
      }

      startup_fetch

      # Prompt
      # PROMPT=$'%B%F{13}Emjauly%b@%m%f → %F{14}%8~%f \n%B%#%b '

      nix-subcommand() {
        cmd="$1"
        shift
        pkgs=()
        for pkg in "$@"; do
          shift
          [ "$pkg" = -- ] && break
          [ "$pkg" = "''${pkg##*#}" ] && pkg="nixpkgs#$pkg"
          pkgs+="$pkg"
        done
        export NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_BROKEN=1
        nix "$cmd" --impure "''${pkgs[@]}" -- "$@"
      }

      shell() { nix-subcommand "shell" "$@" }
      run()   { nix-subcommand "run" "$@"   }
      build() { nix-subcommand "build" "$@" }

      function fcp() {
        ${pkgs.wl-clipboard}/bin/wl-copy < "$@"
      }

      # Completion stuff
      zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
      zstyle ':completion:*' completions 1
      zstyle ':completion:*' file-sort name
      zstyle ':completion:*' format 'Completing %d'
      zstyle ':completion:*' glob 1
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' ignore-parents parent pwd
      zstyle ':completion:*' list-colors ""
      zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
      zstyle ':completion:*' matcher-list "" 'r:|[._-]=** r:|=** l:|=*' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
      zstyle ':completion:*' max-errors 3
      zstyle ':completion:*' menu select=5
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' substitute 1
      zstyle ':completion:*' use-compctl false
      zstyle :compinstall filename '$ZDOTDIR/.zshrc'


      # Vim mode 
      KEYTIMEOUT=1
      MODE_INDICATOR_VIINS='%F{0}%K{#94e59a} INSERT %k%f'
      MODE_INDICATOR_VICMD='%F{0}%K{#7db6ff} NORMAL %k%f'
      MODE_INDICATOR_REPLACE='%F{0}%K{#ff84a7} REPLACE %k%f'
      MODE_INDICATOR_SEARCH='%F{0}%K{13} SEARCH %k%f'
      MODE_INDICATOR_VISUAL='%F{0}%K{#d2a4fe} VISUAL %k%k'
      MODE_INDICATOR_VLINE='%F{0}<%F{4}V-LINE%F{12}>%f'

      # History substring search vi mode
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      # Normal substring search behavior
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"
      ZSH_GIT_PROMPT_SHOW_TRACKING_COUNTS=0
      ZSH_GIT_PROMPT_SHOW_LOCAL_COUNTS=0

      ZSH_THEME_GIT_PROMPT_PREFIX="["
      ZSH_THEME_GIT_PROMPT_SUFFIX="]"
      ZSH_THEME_GIT_PROMPT_SEPARATOR=""
      ZSH_THEME_GIT_PROMPT_DETACHED=""
      ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[cyan]%}"
      ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL=""
      ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX=""
      ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX=""
      ZSH_THEME_GIT_PROMPT_BEHIND="|%{$fg_bold[red]%}"
      ZSH_THEME_GIT_PROMPT_AHEAD="|%{$fg_bold[red]%}"
      ZSH_THEME_GIT_PROMPT_UNMERGED=""
      ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}"
      ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[green]%}"
      ZSH_THEME_GIT_PROMPT_UNTRACKED="|%{$fg_bold[blue]%}..."
      ZSH_THEME_GIT_PROMPT_STASHED=""
      ZSH_THEME_GIT_PROMPT_CLEAN=""

      #Prompt
      VIM_MODE_INITIAL_KEYMAP=viins
      PROMPT='%B%F{13}Emjauly%b@%m%f → %F{14}%8~%f'
      PROMPT+='
      $(gitprompt)'
      PROMPT+='%B%#%b '

      eval "$(zoxide init --cmd cd zsh)"
    '';

    plugins = [
    # zsh-git-prompt
      {
        name = "zsh-vim-mode";
        file = "zsh-vim-mode.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "softmoth";
          repo = "zsh-vim-mode";
          rev = "1f9953b7d6f2f0a8d2cb8e8977baa48278a31eab";
          sha256 = "sha256-a+6EWMRY1c1HQpNtJf5InCzU7/RphZjimLdXIXbO6cQ=";
        };
      }
      {
        name = "git-prompt-zsh";
        file = "git-prompt.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "woefe";
          repo = "git-prompt.zsh";
          rev = "0193adeb09fbc51fac738081a4718a3cf8427ff8";
          sha256 = "sha256-Q7Dp6Xgt5gvkWZL+htDmGYk9RTglOWrrbl6Wf6q/qjY=";
        };
      }
    ];
  };
}
