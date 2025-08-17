{ ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      
      act = wezterm.action
      
      -- Random options 
      
      config.color_scheme = 'Catppuccin Macchiato'
      config.use_fancy_tab_bar = false
      config.canonicalize_pasted_newlines = 'LineFeed'
      --config.initial_cols = 88
      --config.initial_rows = 25
      config.enable_wayland = true
      
      -- Command Palette 
      
      config.command_palette_bg_color = "#363a4f"
      config.command_palette_fg_color = "#cad3f5"
      
      config.window_padding = {
        left   = 4,
        right  = 4,
        top    = 4,
        bottom = 4,
      }

      config.window_background_opacity = 0.95
      
      config.inactive_pane_hsb = {
        saturation = 1,
        brightness = 0.5,
        hue = 1.01724137931,
      }
      
      config.colors = {
        tab_bar = { 
          background = "rgba(36, 39, 58, 0.95)",
          active_tab = { 
            bg_color = "rgba(36, 39, 58, 0.95)",
            fg_color = '#c6a0f6',
          },
          inactive_tab = {
            bg_color = '#1e2030',
            bg_color = "rgba(30, 32, 48, 0.95)",
            fg_color = '#6e738d',
          },
          new_tab = {
            bg_color = "rgba(36, 39, 58, 0.95)",
            fg_color = '#24273a',
          },
        },
        split = '#303446',
      }
      
      wezterm.on('update-status', function(window, pane)
        window:set_left_status(wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { Color = '#c6a0f6' } },
          { Text = ' Hiiii ^-^ ' },
          { Foreground = { Color = '#6e738d' } },
          { Text = '||' },
        })
      end)
      
      wezterm.on('update-status', function(window, pane)
        window:set_right_status(wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { Color = '#a0dee5' } },
          { Text = 'meow  ' },
        })
      end)
      
      font = wezterm.font_with_fallback {
        'MonaspiceRn Nerd Font',
        'Hack',
        'Fira Code',
      }

      config.font = font 
      config.font_size = 13.0
      
      config.adjust_window_size_when_changing_font_size = false

      local is_linux = string.find(wezterm.target_triple, 'linux') ~= nil
      local is_mac = string.find(wezterm.target_triple, 'apple') ~= nil
      
      local mod = {}
      
      if is_mac then 
        mod.SUPER = 'SUPER'
        mod.shiftSUPER= 'SUPER|SHIFT'
        mod.ALT = 'ALT'
      elseif is_linux then
        mod.SUPER = 'SUPER'
        mod.shiftSUPER = 'SUPER|SHIFT'
        mod.ALT = 'ALT'
      end
      
      keys = { 
        {
          key = 't',
          mods = mod.ALT,
          action = act.SpawnTab "CurrentPaneDomain",
        },
        {
          key = 'w',
          mods = mod.SUPER,
          action = act.CloseCurrentPane { confirm = false },
        },
        {
          key = 'd',
          mods = mod.SUPER,
          action = act.SplitPane { direction = 'Right'},
        },
        {
          key = 'd',
          mods = mod.shiftSUPER,
          action = act.SplitPane {direction = 'Down'},
        },
        {
          key = 's',
          mods = mod.SUPER,
          action = act.SplitPane {direction = 'Left'},
        },
        {
          key = 's',
          mods = mod.shiftSUPER,
          action = act.SplitPane {direction = 'Up'},
        },
        {
          key = 'L',
          mods = 'SHIFT|CTRL',
          action = act.SendKey {
            key = 'l',
            mods = 'CTRL',
          },
        },
        {
          key = 'Enter',
          mods = mod.shiftSUPER, 
          action = act.TogglePaneZoomState
        }
      }
      
      for i = 1, 8 do
        table.insert(keys, {
          key = tostring(i),
          mods = mod.ALT,
         action = act.ActivateTab(i - 1),
        })
      end
      
      for key, dir in pairs({ h = 'Left', j = 'Down', k = 'Up', l = 'Right' }) do
        table.insert(keys, {
          key = key,
          mods = 'CTRL',
          action = act.AdjustPaneSize { dir, 1 },
        })
        table.insert(keys, {
          key = key,
          mods = mod.ALT, -- Mayhaps change to mod.SUPER as well ? 
          action = act.ActivatePaneDirection(dir),
        })
      end

      config.keys = keys
      
      return config
    '';
  };
}
