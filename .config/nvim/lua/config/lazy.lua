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
	-- lsp
	{ import = "plugins.lsp" },
	{ import = "plugins.lsp_signature" },
	-- 自動で対応する括弧とか補完してくれるやつ
	{ import = "plugins.autopairs" },
	-- NOTE:みたいにhighlightしてくれるやつ
	{ import = "plugins.todo_comments" },
	-- 行の左側で色々知らせてくれるやつ
	{ import = "plugins.gitsigns" },
	-- git TUI
	{ import = "plugins.lazygit" },
	-- simple todo&notopad
	{ import = "plugins.dooing" },
	-- markdown preview
	{ import = "plugins.markdown_preview" },
	-- いろいろ詰め合わせ。今はimageだけ使ってる
	{ import = "plugins.snacks" },
	-- bufferをタブとして表示してくれるやつ
	{ import = "plugins.barbar" },
	-- 下のステータスバー
	{ import = "plugins.lualine" },
	-- ファイルを階層的に表示してくれる
	{ import = "plugins.nvim_tree" },
	-- neovim内のpaneをresizeできる
	{ import = "plugins.winresizer" },
	-- foldするやつ
	{ import = "plugins.nvim_ufo" },

	{ import = "plugins.toggleterm" },
	{ import = "plugins.hlchunk" },
	{ import = "plugins.render_markdown" },
	{ import = "plugins.img_clip" },
	{ import = "plugins.quick_scope" },
	-- other
	{ import = "plugins.blink_cmp" },
	{ import = "plugins.conform" },
	{ import = "plugins.mini" },
	{ import = "plugins.nvim_transitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.vimenter" },
	-- { import = "plugins.none_ls" },
	-- { import = "plugins.image" },
	-- { import = "plugins.obsidian_bridge" },
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
