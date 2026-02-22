-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run
--    :Lazy
--  To update plugins you can run
--    :Lazy update
require("lazy").setup({

	-- nvim/lua/plugins/
	-- colorscheme
	{ import = "plugins.catppuccin" },
	-- show keymaps randomly
	{ import = "plugins.random_key_tips" },
	-- lsp
	{ import = "plugins.lsp" },
	{ import = "plugins.lsp_signature" },
	-- auto complete pairs like `{}`
	{ import = "plugins.autopairs" },
	-- NOTE: comment highlight
	{ import = "plugins.todo_comments" },
	-- for checking git status line by line
	{ import = "plugins.gitsigns" },
	-- git TUI
	{ import = "plugins.lazygit" },
	-- simple todo&notopad
	{ import = "plugins.dooing" },
	-- beautiful notify
	{ import = "plugins.nvim_notify" },
	-- markdown preview in brawser(for cant inline image preview)
	{ import = "plugins.markdown_preview" },
	-- display buffer like tab
	{ import = "plugins.barbar" },
	-- status bar
	{ import = "plugins.lualine" },
	-- display directories hierarchically
	{ import = "plugins.nvim_tree" },
	-- pane resizer
	{ import = "plugins.winresizer" },
	-- fold/unfold
	{ import = "plugins.nvim_ufo" },
	-- terminal
	{ import = "plugins.toggleterm" },
	-- display line on indent
	{ import = "plugins.hlchunk" },
	-- inline markdown preview
	{ import = "plugins.render_markdown" },
	-- image paster
	{ import = "plugins.img_clip" },
	-- highlight unique charactor in line to help `f` `F`...
	{ import = "plugins.quick_scope" },
	-- completion
	{ import = "plugins.blink_cmp" },
	-- auto formatter
	{ import = "plugins.conform" },
	-- collection of utillity plugins
	{ import = "plugins.mini" },
	-- parsing highlighting
	{ import = "plugins.nvim_transitter" },
	-- fuzzy finder
	{ import = "plugins.telescope" },
	-- show pending keybind
	{ import = "plugins.which_key" },

	-- disable
	-- ?
	-- { import = "plugins.none_ls" },
	-- collenction of utillity plugins. now use image only
	-- disable: want to use wezterm, so now use markdown image preview in browser
	-- { import = "plugins.snacks" },
	-- inline image preview
	-- disable: same as above
	-- { import = "plugins.image" },
	-- A plugin for synchronous operation with Obsidian
	-- disable: no need
	-- { import = "plugins.obsidian_bridge" },
	-- ?
	-- { import = "plugins.git_messanger" },
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
