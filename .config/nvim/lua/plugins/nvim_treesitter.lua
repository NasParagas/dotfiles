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
			--
			-- require("nvim-treesitter").setup({
			-- 	install_dir = vim.fn.stdpath("data") .. "/site",
			-- })

			require("nvim-treesitter").install(parsers)

			-- Metal Shading Language is C++ based; reuse the cpp parser
			vim.treesitter.language.register("cpp", "metal")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sh",
					"c",
					"cpp",
					"metal",
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
