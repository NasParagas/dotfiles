return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		keys = {
			{ "<C-]>", "<Cmd>BufferNext<CR>", desc = "Next Buffer" },
			{ "<C-[>", "<Cmd>BufferPrevious<CR>", desc = "Previous Buffer" },
			-- {"", "", desc = "~番目のbufferへ"},
			{ "<leader>w", "<Cmd>BufferClose<CR>", desc = "close current buffer" },
			{ "<leader><C-w>", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "close other all buffer " },
		},
		version = "^1.0.0",
	},
}
