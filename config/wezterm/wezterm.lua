local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12.0
config.use_ime = true
config.audible_bell = "Disabled"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Catppuccin Mocha'

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" }
}
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#ffffff"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8d2d"
    foreground = "#ffffff"
  end

  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- tmux/vim/nvim 等が有効化した mouse reporting を解除する
local function disable_mouse_reporting(pane)
  pane:inject_output(
    '\x1b[?1000l' .. -- X10 mouse reporting
    '\x1b[?1002l' .. -- Button-event tracking
    '\x1b[?1003l' .. -- Any-event tracking
    '\x1b[?1005l' .. -- UTF-8 mouse mode
    '\x1b[?1006l' .. -- SGR mouse mode
    '\x1b[?1015l'    -- urxvt mouse mode
  )
end

-- pane ごとに「直前が ssh だったか」を覚える
local was_ssh = {}

wezterm.on('update-status', function(window, pane)
  local pane_id = pane:pane_id()
  local process = pane:get_foreground_process_name() or ''
  local basename = process:match('([^/\\]+)$') or process

  local is_ssh =
    basename == 'ssh' or
    basename == 'mosh-client' or
    basename == 'mosh'

  -- ssh/mosh 中は記録だけする
  if is_ssh then
    was_ssh[pane_id] = true
    return
  end

  -- 直前まで ssh/mosh で、今はローカル shell に戻ったなら解除する
  if was_ssh[pane_id] then
    disable_mouse_reporting(pane)
    was_ssh[pane_id] = false

    -- 不要ならこの通知は消してよい
    window:toast_notification(
      'WezTerm',
      'Mouse reporting disabled after SSH exit',
      nil,
      1500
    )
  end
end)

return config
