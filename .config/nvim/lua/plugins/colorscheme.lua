return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			transparent_background = true,
			styles = {},
		},
		-- config = function(opts)
		-- 	require("catppuccin").setup(opts)
		-- 		vim.cmd("colorscheme catppuccin")
		-- end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			-- style depends on backgroud theme
			transparent_mode = true,
		},
		-- config = function(_, opts)
		-- 	require("gruvbox").setup(opts)
		-- 	vim.cmd("colorscheme gruvbox")
		-- end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {
			style = "night", -- moon, night, day, storm
			transparent = true,
		},
		-- config = function(opts)
		-- 	require("tokyonight").setup(opts)
		-- 	vim.cmd("colorscheme tokyonight")
		-- end,
	},
}
