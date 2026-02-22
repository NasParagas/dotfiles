local function set_colorscheme(theme_name)
	local status_ok, err = pcall(vim.cmd, "colorscheme " .. theme_name)
	if not status_ok then
		vim.notify("error: " .. err, vim.log.levels.WARN)
		vim.cmd("colorscheme default")
	end
end

-- background setting
-- vim.o.background = "light"
vim.o.background = "dark"

-- colorscheme setting
-- set_colorscheme("catppuccin")
set_colorscheme("gruvbox")
-- set_colorscheme("tokyonight")
