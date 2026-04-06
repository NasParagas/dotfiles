return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	opts = {
		delete_to_trash = false,
		view_options = {
			-- show_hidden = true,
		},
	},

	keys = { vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }) },
}
