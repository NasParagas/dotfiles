return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		keys = {
			{ mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする" },
			{ mode = "n", "<C-m>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカス" },
		},
		opts = {
			filesystem_watchers = {
				enable = true, -- 変更監視を有効化
				debounce_delay = 50, -- 更新のデバウンス
			},
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = { enable = true, update_root = true },
			filters = {
				dotfiles = false,
				custom = { ".DS_store" },
				exclude = {},
			},
			git = {
				ignore = false,
			},
		},
	},
}
