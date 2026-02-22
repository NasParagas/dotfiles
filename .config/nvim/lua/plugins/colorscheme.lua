return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "macchiato", -- latte(light), frappe, macchiato, mocha
			transparent_background = true,
			styles = {},
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			-- style depends on backgroud theme
			transparent_mode = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {
			style = "night", -- moon, night, day, storm
			transparent = true,
		},
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
}
