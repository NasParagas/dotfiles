local wezterm = require("wezterm")

-- reload when update config
local config = wezterm.config_builder()
config.automatically_reload_config = true

-- font setting
config.font_size = 13
config.font = wezterm.font("HackGen35 Console NF")

-- window setting --
-- initail window size
config.initial_cols = 120
config.initial_rows = 28
-- window opacity
config.window_background_opacity = 0.75
-- background blur
config.macos_window_background_blur = 2
-- window titlebar and bordar setting
-- NONE: desable titlebar and border
-- TITLE: desable resizable border
-- RESIZE: desable title bar
-- TITLE | RESIZE: enable both (default)
config.window_decorations = "RESIZE"

-- tab setting
-- transparent
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
-- config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- inherit docker when split pane
local function split_and_inhert_docker(direction)
	return wezterm.action_callback(function(window, pane)
		local process_info = pane:get_foreground_process_info()
		local cwd_uri = pane:get_current_working_dir()
		local cwd = cwd_uri and cwd_uri.file_path or nil
		local swawn_args = nil

		--
		if process_info and process_info.argv then
			local cmd = process_info.argv[1]
			if cmd and (cmd:match("docker$") or cmd:match("docker%-compose$")) then
				for _, arg in ipairs(process_info.argv) do
					if arg == "exec" then
						spawn_args = process_info.argv
						break
					end
				end
			end
		end

		local action
		if direction == "Right" then
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain", args = spawn_args, cwd = cwd })
		elseif direction == "Bottom" then
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain", args = spawn_args, cwd = cwd })
		end

		window:perform_action(action, pane)
	end)
end

-- keymaps
config.keys = {
	-- split pane
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
}

return config
