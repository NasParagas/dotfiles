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

	----- Appearance / UI -----
	-- all colorscheme
	{ import = "plugins.colorscheme" },
	-- colorscheme selector
	{ import = "plugins.themery" },
	-- status bar
	{ import = "plugins.lualine" },
	-- display line on indent
	{ import = "plugins.hlchunk" },
	-- show pending keybind
	{ import = "plugins.which_key" },
	-- show keymaps randomly
	{ import = "plugins.random_key_tips" },

	----- LSP / Coding Support -----
	-- language server protocol
	{ import = "plugins.lsp" },
	-- show function signature when typing
	{ import = "plugins.lsp_signature" },
	-- completion engine
	{ import = "plugins.blink_cmp" },
	-- auto formatter
	{ import = "plugins.conform" },
	-- parsing & highlighting
	{ import = "plugins.nvim_treesitter" },
	-- Shows virtual text of the current context after functions, methods, statements
	{ import = "plugins.nvim_context_vt" },
	-- splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
	{ import = "plugins.treesj" },

	----- Editor Enhancements -----
	-- auto complete pairs like `{}`
	{ import = "plugins.autopairs" },
	-- extended increment/decrement
	{ import = "plugins.dial" },
	-- fold/unfold enhancement
	{ import = "plugins.nvim_ufo" },
	-- pane resizer
	{ import = "plugins.winresizer" },

	----- Navigation -----
	-- fuzzy finder
	{ import = "plugins.telescope" },
	-- file explorer (editing like a buffer)
	{ import = "plugins.oil" },
	-- highlight f/F/t/T jump targets
	{ import = "plugins.quick_scope" },
	--
	{ import = "plugins.flash" },

	----- Git -----
	-- for checking git status line by line
	{ import = "plugins.gitsigns" },
	-- git TUI
	{ import = "plugins.lazygit" },
	-- git diffview
	{ import = "plugins.diffview" },
	-- show commit message under cursor
	{ import = "plugins.git_messanger" },

	----- Writing / Productivity -----
	-- markdown preview in browser
	{ import = "plugins.live_preview" },
	-- render markdown in buffer
	{ import = "plugins.render_markdown" },
	-- comment highlight & search
	{ import = "plugins.todo_comments" },
	-- image paster
	{ import = "plugins.img_clip" },
	-- exit pair symbol ealily
	{ import = "plugins.in-and-out" },
	-- autopair ex.<div></div>
	{ import = "plugins.nvim-ts-autotag" },

	----- Utilities -----
	-- collection of utility plugins
	{ import = "plugins.mini" },
	-- terminal integration
	{ import = "plugins.toggleterm" },

	----- Disabled / Unused -----
	-- LaTeX math preview
	-- { import = "plugins.nabla" },
	----- AI Support -----
	-- github copilot
	-- { import = "plugins.copilot" },
	-- AI chat & code companion
	-- { import = "plugins.codecompanion" },

	-- { import = "plugins.none_ls" },
	-- { import = "plugins.snacks" },
	-- { import = "plugins.image" },
	-- { import = "plugins.obsidian_bridge" },
	-- { import = "plugins.wrapped" },
	-- { import = "plugins.nvim_jdtls" },
	-- { import = "plugins.nvim_notify" },
	-- { import = "plugins.barbar" },
	-- { import = "plugins.markdown_preview" },
	-- { import = "plugins.markview" },
	-- { import = "plugins.nvim_tree" },
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
