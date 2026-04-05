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

	-- nvim/lua/plugins/**

	----- colorscheme -----
	-- all colorscheme
	{ import = "plugins.colorscheme" },
	-- colorscheme selector
	{ import = "plugins.themery" },

	----- lsp -----
	{ import = "plugins.lsp" },
	{ import = "plugins.lsp_signature" },
	-- completion
	{ import = "plugins.blink_cmp" },
	-- auto formatter
	{ import = "plugins.conform" },

	----- git -----
	-- for checking git status line by line
	{ import = "plugins.gitsigns" },
	-- git TUI
	{ import = "plugins.lazygit" },

	----- Markdown preview -----
	-- markdown preview in brawser
	-- maybe wont use in neovim v0.12, and no maintainer
	-- { import = "plugins.markdown_preview" },
	-- LGTM
	{ import = "plugins.live_preview" },
	-- inline markdown preview
	-- 表示崩れるから微妙という気がしてきていた
	-- { import = "plugins.render_markdown" },
	-- { import = "plugins.markview" },

	----- File management -----
	-- { import = "plugins.nvim_tree" },
	{ import = "plugins.oil" },

	-- show keymaps randomly
	{ import = "plugins.random_key_tips" },
	-- auto complete pairs like `{}`
	{ import = "plugins.autopairs" },
	-- comment highlight
	{ import = "plugins.todo_comments" },
	-- simple todo&notopad
	{ import = "plugins.dooing" },
	-- beautiful notify
	-- { import = "plugins.nvim_notify" },

	-- display buffer like tab
	-- { import = "plugins.barbar" },
	-- status bar
	{ import = "plugins.lualine" },
	-- pane resizer
	{ import = "plugins.winresizer" },
	-- fold/unfold
	{ import = "plugins.nvim_ufo" },
	-- terminal
	{ import = "plugins.toggleterm" },
	-- display line on indent
	{ import = "plugins.hlchunk" },
	-- image paster
	{ import = "plugins.img_clip" },
	-- collection of utillity plugins
	{ import = "plugins.mini" },
	-- parsing highlighting
	{ import = "plugins.nvim_treesitter" },
	-- fuzzy finder
	{ import = "plugins.telescope" },
	-- show pending keybind
	{ import = "plugins.which_key" },
	-- git diffview
	{ import = "plugins.diffview" },
	----- disables -----
	-- formatter
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
	-- git tracker
	-- { import = "plugins.wrapped" },
	-- java
	-- { import = "plugins.nvim_jdtls" },
	-- highlight unique charactor in line to help `f` `F`...
	-- { import = "plugins.quick_scope" },
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
