local wezterm = require("wezterm")

-- reload when update config
local config = wezterm.config_builder()
config.automatically_reload_config = true

-- windows以外だったらbash起動
if not wezterm.target_triple:find("windows") then
	config.default_prog = { "/bin/bash", "-l" }
end

-- font setting
config.font_size = 13
config.font = wezterm.font("HackGen35 Console NF", { weight = "Bold" })

-- log
config.scrollback_lines = 10000

-- window setting --
-- initail window size
config.initial_cols = 120
config.initial_rows = 28
-- window opacity
config.window_background_opacity = 0.85
-- background blur
-- config.macos_window_background_blur = 2
-- window titlebar and bordar setting
-- NONE: desable titlebar and border
-- TITLE: desable resizable border
-- RESIZE: desable title bar
-- TITLE | RESIZE: enable both (default)
config.window_decorations = "RESIZE"
config.audible_bell = "Disabled"

-- tab setting
-- transparent
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- other setting
config.hide_mouse_cursor_when_typing = true

-- keymaps
config.keys = {
	-- -- split pane
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
	-- close pane
	{
		key = "w",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- move on pane
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
	-- -- resize pane
	-- {
	-- 	key = "-",
	-- 	mods = "SHIFT|CTRL",
	-- 	action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	-- },
	-- {
	-- 	key = "+",
	-- 	mods = "SHIFT|CTRL",
	-- 	action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	-- },

	-- tab名変更
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

return config
