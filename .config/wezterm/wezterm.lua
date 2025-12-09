local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.automatically_reload_config = true

-- 起動時のウィンドウサイズ
config.initial_cols = 120
config.initial_rows = 28

-- フォント設定
config.font_size = 12
config.font = wezterm.font("HackGen35 Console NF")

-- ウィンドウ設定
-- 背景の透明度
config.window_background_opacity = 0.7
-- 背景のブラー
config.macos_window_background_blur = 2
-- ウィンドウ名削除(本当は削除するだけじゃなさそう)
config.window_decorations = "RESIZE"

-- タブ設定
-- タブが一つだけの時タブバーを非表示
config.hide_tab_bar_if_only_one_tab = true
-- タブバーを透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
-- タブバーの+を非表示(cmd+tでタブ追加)
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- keymaps
config.keys = {
	-- paneを左と下側に分割
	{
		key = "e",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "o",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- paneを閉じる
	{
		key = "w",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- pane移動
	{
		key = "h",
		mods = "SHIFT|CTRL",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "SHIFT|CTRL",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "SHIFT|CTRL",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "SHIFT|CTRL",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

-- Finally, return the configuration to wezterm:
return config
