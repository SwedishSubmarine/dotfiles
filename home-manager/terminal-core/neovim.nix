{ pkgs, ... }:
{
  programs.neovim = {
    enable=true;
    defaultEditor = true;
    extraConfig = ''
      autocmd FileType markdown setlocal textwidth=80 wrapmargin=0 linebreak formatoptions+=t
    '';
    extraLuaConfig = ''
    ----------------------------------------------------------------------------
    -- Default options 

    vim.opt.clipboard = 'unnamedplus'  -- system clipboard
    vim.opt.cot = {'menu', 'noselect'} -- might remove, complete menu
    vim.o.swapfile = false
    vim.g.mapleader = " "

    -- Tab configuration
    vim.o.expandtab = true -- make tabs spaces
    vim.o.tabstop = 2      -- visual spaces per TAB
    vim.o.shiftwidth = 2   -- insert spaces on a tab
    
    -- Basic UI 
    vim.o.signcolumn = "yes" 
    vim.o.winborder = "rounded"
    vim.o.number = true         -- show absolute for current line
    vim.o.relativenumber = true -- add relative numbers as well
    vim.o.splitbelow = true     -- adds vertical split below
    vim.o.splitright = true     -- adds horizontal split right
    vim.o.ls = 3                -- tells when last window has status line
    vim.o.cursorline = true     -- Slight highlight of entire line 
    vim.o.cursorlineopt = "line,number"
    
    -- Searching
    vim.o.incsearch = true      -- search as entered (increment 
    vim.o.ignorecase = true     -- ignore case
    vim.o.smartcase = true      -- case sensitive on uppercase 
    vim.o.hlsearch = true

    -- Default wrap settings
    vim.o.textwidth = 0
    vim.o.wrapmargin = 0
    vim.o.wrap = true
    vim.o.linebreak = true

    ---------------------------------------------------------------------------
    -- Keybindings

    local opts = { noremap = true, silent = true }
    
    -- Other kepmappings
    vim.keymap.set('n', 'x', '"_x') -- Make x send to blackhole and not act as cut
    vim.keymap.set('n', 'j', 'gj')
    vim.keymap.set('n', 'k', 'gk') -- I almost always want this
    vim.keymap.set('n', 'gj', 'j')
    vim.keymap.set('n', 'gk', 'k')
    vim.keymap.set('n', '<leader>w', ':write <CR>')
    vim.keymap.set('n', '<leader>c', ':noh <CR>') -- Clear search

    -- Pick 
    vim.keymap.set('n', '<leader>f', ':Pick files <CR>')
    vim.keymap.set('n', '<leader>h', ':Pick help <CR>')
    
    -- LSP
    vim.lsp.enable({ "lua_ls" })
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
    vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>N', vim.diagnostic.goto_prev, opts)

    vim.keymap.set('n', '<leader>t', ':pop <CR>')
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-n>', vim.lsp.omnifunc, opts)
    local nvim_lsp = require("lspconfig")
    nvim_lsp.nixd.setup({
      cmd = { "nixd" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }",
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.Adamantite.options',
            },
            home_manager = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.Adamantite.options.home-manager.users.type.getSubOptions []',
            },
          },
        },
      },
    })

    ---------------------------------------------------------------------------
    -- Colorscheme
    require("transparent").setup({
      extra_groups = {
        "NormalFloat"
      },
      exclude_groups = {
        "CursorLine"
      },
    })

    local colorscheme = 'catppuccin-macchiato'
    
    local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not is_ok then
        vim.notify('colorscheme ' .. colorscheme .. ' not found!')
        return
    end
    ---------------------------------------------------------------------------
    -- Plugins

    -- Lualine
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'catppuccin',
          component_separators = { left = "", right = ""},
          section_separators = { left = "", right = ""},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
           lualine_a = {'mode'},
           lualine_b = { { 
             'diagnostics', 
             always_visible = true,
             on_click = function(n,b,m)
               vim.diagnostic.goto_next()
             end
          } },
          lualine_c = {{'filename',path=3,}},
          lualine_x = {'encoding'},
          lualine_y = {'filetype'},
          lualine_z = {'location'}
        },
      }

      -- nvim-cmp
      local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` 
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- Use <C-b/f> to scroll the docs
          ['<C-b>'] = cmp.mapping.scroll_docs( -4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- Use <C-k/j> to switch in items
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          -- Use <CR>(Enter) to confirm selection
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

          -- A super tab
          -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
          ["<Tab>"] = cmp.mapping(function(fallback)
              -- Hint: if the completion menu is visible select next one
              if cmp.visible() then
                  cmp.select_next_item()
              elseif has_words_before() then
                  cmp.complete()
              else
                  fallback()
              end
          end, { "i", "s" }), -- i - insert mode; s - select mode
          ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item()
              elseif luasnip.jumpable( -1) then
                  luasnip.jump( -1)
              else
                  fallback()
              end
          end, { "i", "s" }),
        }),

        -- Let's configure the item's appearance
        -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
        formatting = {
          -- Set order from left to right
          -- kind: single letter indicating the type of completion
          -- abbr: abbreviation of "word"; when not empty it is used in the menu instead of "word"
          -- menu: extra text for the popup menu, displayed after "word" or "abbr"
          fields = { 'abbr', 'menu' },
        
          -- customize the appearance of the completion menu
          format = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = '[Lsp]',
            luasnip = '[Luasnip]',
            buffer = '[File]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
          end,
        },

        -- Set source precedence
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },    -- For nvim-lsp
          { name = 'luasnip' },     -- For luasnip user
          --{ name = 'buffer' },      -- For buffer word completion
          { name = 'path' },        -- For path completion
          { name = 'emoji' },       -- For emojis!! 
        })
      })

      -- The homies
      require('nvim-surround').setup()
      require("ibl").setup()
      require('mini.icons').setup()
      require('mini.pick').setup()
      require('numb').setup{
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking()
        hide_relativenumbers = false, -- Enable turning off 'relativenumber' for the window while peeking
        number_only = true, -- Peek only when the command is only a number instead of when it starts with a number
        centered_peeking = true, -- Peeked line will be centered relative to window
      }
    '';

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      catppuccin-nvim
      lualine-nvim
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
    ];

    extraPackages = with pkgs; [
      nixd
      lua-language-server
    ];
  };
}
