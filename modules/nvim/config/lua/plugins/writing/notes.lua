return {
	dir = "~/work/nvim-notes",
	name = "nvim-notes",
	main = "notes",
	cond = function()
		return vim.fn.isdirectory(vim.fn.expand("~/work/nvim-notes")) == 1
	end,
	-- gf の設定は FileType で行うので、md を直接開くときはその前に読み込む
	event = { "VeryLazy", "BufReadPre *.md", "BufNewFile *.md" },
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {
		vault = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
	},
}
