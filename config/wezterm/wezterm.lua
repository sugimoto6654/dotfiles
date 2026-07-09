local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12.0
config.use_ime = true
config.audible_bell = "Disabled"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Catppuccin Mocha'

-- ~/.ssh/config の Host エントリから ssh_domains を自動生成する
config.ssh_domains = wezterm.default_ssh_domains()

-- ShowLauncher は既定でキーバインドが無いため追加する
config.keys = {
  { key = '9', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
}

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
  -- タブバー（fancy tab bar）のフォント。指定しないとNerd Fontアイコンが正しい幅で
  -- 描画されず、文字と被って見えるため本体と同じフォントを指定する
  font = wezterm.font("Hack Nerd Font"),
  -- タブバーの文字サイズ。既定は10.0でやや小さいので少し大きくする
  font_size = 12.0,
}
config.window_background_gradient = {
  colors = { "#000000" }
}
config.show_close_tab_button_in_tabs = false
config.tab_bar_at_bottom = false

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    -- 斜めの powerline 風グリフをやめ、四角い形のタブにする
    tab_separators = {
      left = '',
      right = '',
    },
    -- NORMAL/default など左端セクション間の区切りも同様に四角くする
    section_separators = {
      left = '',
      right = '',
    },
    component_separators = {
      left = '',
      right = '',
    },
  },
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = {},
    tab_active = {
      'index',
      { 'process', padding = { left = 0, right = 1 } },
    },
    tab_inactive = {
      'index',
      { 'process', padding = { left = 0, right = 1 } },
    },
    -- CPU/RAM は負荷状況、hostname/domain は接続先を示すグループとして分ける
    tabline_x = { 'cpu', 'ram' },
    tabline_y = { 'battery' },
    tabline_z = { 'domain' },
  },
})

tabline.apply_to_config(config)

-- tabline.wez は apply_to_config 内で use_fancy_tab_bar = false にしてしまうため、
-- window_frame.font_size が効かない（retro tab bar はターミナル本体と同じフォントサイズになる）。
-- fancy tab bar に戻すことで window_frame.font_size を有効化する。
config.use_fancy_tab_bar = true

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
