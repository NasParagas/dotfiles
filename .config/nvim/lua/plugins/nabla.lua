return {
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "tree-sitter-cli" } },
	},

	{
		"jbyuki/nabla.nvim",
		dependencies = {
			"nvim-neo-tree/neo-tree.nvim",
			"williamboman/mason.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,

		-- これらのファイルを開いた時に読み込む
		ft = { "markdown", "tex" },

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "latex" },
				auto_install = true,
				sync_install = false,
			})

			require("nabla").enable_virt({
				autogen = true,
				silent = true,
			})
		end,

		keys = function()
			return {
				{
					"<leader>l",
					':lua require("nabla").popup()<cr>',
					desc = "NablaPopUp",
				},
			}
		end,
	},
}
