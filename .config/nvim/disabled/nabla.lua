return {
	{
		"jbyuki/nabla.nvim",
		dependencies = {
			"nvim-neo-tree/neo-tree.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,

		-- これらのファイルを開いた時に読み込む
		ft = { "markdown", "tex" },

		config = function()
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
