return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"bash",
				"c",
				"cpp",
				"cmake",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				"latex",
				"css",
				"python",
				"query",
				"vim",
				"vimdoc",
			}

			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sh",
					"c",
					"cpp",
					"cmake",
					"diff",
					"html",
					"lua",
					"markdown",
					"javascript",
					"typescript",
					"css",
					"python",
					"query",
					"vim",
					"help",
				},
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
}
