{ pkgs, theme, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      autocmd FileType markdown setlocal textwidth=80 wrapmargin=0 linebreak formatoptions+=t spell spelllang=en_us

    set wildmenu
    set wildoptions=pum,fuzzy
    set completeopt=menuone,fuzzy,noinsert

    "Vimtex
    filetype plugin on
    syntax enable

    let g:vimtex_view_method = 'zathura'
    '';
    extraLuaConfig = builtins.readFile ./init.lua + ''
    -- These are oddities due to how I handle themeing 
    -------------------------------------------------------------------------
    -- Colorscheme
    -- Gruvbox config
    -------------------------------------------------------------------------
      require("gruvbox").setup({
        overrides = {
          SignColumn = {fg = "#${theme.gruvbox.accent}"},
          ["@markup.heading.1.markdown"] = {fg = "#${theme.gruvbox.accent2}"},
          ["@markup.heading.2.markdown"] = {fg = "#${theme.gruvbox.green}"},
          ["@markup.heading.3.markdown"] = {fg = "#${theme.gruvbox.teal}"},
          ["@markup.heading.4.markdown"] = {fg = "#${theme.gruvbox.blue}"},
          ["@markup.heading.5.markdown"] = {fg = "#${theme.gruvbox.purple}"},
          ["@markup.heading.6.markdown"] = {fg = "#${theme.gruvbox.red}"},
          ["RenderMarkdownH1Bg"] = {bg = "#${theme.gruvbox.accent2}",fg = "#${theme.gruvbox.overlay2}"},
          ["RenderMarkdownH2Bg"] = {bg = "#${theme.gruvbox.green}",   fg = "#${theme.gruvbox.overlay2}"},
          ["RenderMarkdownH3Bg"] = {bg = "#${theme.gruvbox.teal}", fg = "#${theme.gruvbox.overlay2}"},
          ["RenderMarkdownH4Bg"] = {bg = "#${theme.gruvbox.blue}",   fg = "#${theme.gruvbox.overlay2}"},
          ["RenderMarkdownH5Bg"] = {bg = "#${theme.gruvbox.purple}",  fg = "#${theme.gruvbox.overlay2}"},
          ["RenderMarkdownH6Bg"] = {bg = "#${theme.gruvbox.red}",    fg = "#${theme.gruvbox.overlay2}"},
          ["markdownH1"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownH2"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownH3"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownH4"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownH5"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownH6"] = { fg = "#${theme.gruvbox.accent}"},
          ["Search"] = { fg = "#${theme.gruvbox.cyan}"},
          ["CurSearch"] = { fg = "#${theme.gruvbox.teal}"},
          ["markdownBold"] = { fg = "#${theme.gruvbox.accent}"},
          ["markdownBoldItalic"] = { fg = "#${theme.gruvbox.pink}"}
        }
      })

      -------------------------------------------------------------------------
      '' + theme.current.nvim + "\n" + '' 
      require("transparent").setup({
        extra_groups = {
          "NormalFloat"
        },
        exclude_groups = {
          "CursorLine"
        },
      })
      -----------------------------------------------------------------------
      -- Indent blankline
      -----------------------------------------------------------------------
      local highlight = {
        "Red",
        "Yellow",
        "Blue",
        "Orange",
        "Green",
        "Purple",
        "Cyan",
      }
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "Red",     { fg = "#${theme.current.red}" })
        vim.api.nvim_set_hl(0, "Yellow",  { fg = "#${theme.current.yellow}" })
        vim.api.nvim_set_hl(0, "Blue",    { fg = "#${theme.current.blue}" })
        vim.api.nvim_set_hl(0, "Orange",  { fg = "#${theme.current.orange}" })
        vim.api.nvim_set_hl(0, "Green",   { fg = "#${theme.current.green}" })
        vim.api.nvim_set_hl(0, "Purple",  { fg = "#${theme.current.purple}" })
        vim.api.nvim_set_hl(0, "Cyan",    { fg = "#${theme.current.cyan}" })
      end)
      require("ibl").setup { 
        indent = { 
          highlight = highlight, 
          char = "┆"
        }
      }
    '';
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      gruvbox-nvim
      lualine-nvim
      nvim-web-devicons
      mini-icons
      indent-blankline-nvim
      luasnip
      lspkind-nvim
      nvim-cmp
      cmp-emoji
      cmp-nvim-lsp
      cmp-path
      cmp-cmdline
      cmp-buffer
      numb-nvim
      nvim-lspconfig
      mini-pick
      nvim-surround
      vimtex
      transparent-nvim
      render-markdown-nvim
      nvim-colorizer-lua
      which-key-nvim
      telescope-nvim
      popup-nvim
      telescope-media-files-nvim
      switch-vim
    ];

    extraPackages = with pkgs; [
      nixd
      lua-language-server
      tinymist
      vscode-langservers-extracted
      haskell-language-server
      java-language-server
    ];
  };
}
