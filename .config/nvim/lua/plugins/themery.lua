return {
	"zaldih/themery.nvim",
	lazy = false,
	opts = {
		themes = {
			{
				name = "Tokyonight Storm",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "storm",
					})
				]],
			},
			{
				name = "Tokyonight Storm Transparent",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "storm",
						transparent = true,
                        styles = {
                          sidebars = "transparent",
                          floats = "transparent",
                        },
					})
				]],
			},
			{
				name = "Tokyonight Moon",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "moon",
					})
				]],
			},
			{
				name = "Tokyonight Moon Transparent",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "moon",
						transparent = true,
                        styles = {
                          sidebars = "transparent",
                          floats = "transparent",
                        },
					})
				]],
			},
			{
				name = "Tokyonight Night",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "night",
					})
				]],
			},
			{
				name = "Tokyonight Day",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "day",
					})
				]],
			},

			{
				name = "Gruvbox Dark",
				colorscheme = "gruvbox",
				before = [[
					require("gruvbox").setup({ })
					vim.o.background = "dark"
				]],
			},
			{
				name = "Gruvbox Dark Transparent",
				colorscheme = "gruvbox",
				before = [[
					require("gruvbox").setup({
						transparent_mode = true,
					})
					vim.o.background = "dark"
				]],
			},

			{
				name = "Catppuccin Mocha",
				colorscheme = "catppuccin",
				before = [[
					require("catppuccin").setup({
						flavour = "mocha",
					})
				]],
			},
			{
				name = "Catppuccin Mocha Transparent",
				colorscheme = "catppuccin",
				before = [[
					require("catppuccin").setup({
						flavour = "mocha",
						transparent_background = true,
					})
				]],
			},

			{
				name = "Kanagawa Wave",
				colorscheme = "kanagawa",
				before = [[
					require("kanagawa").setup({
						theme = "Wave",
                      })
				]],
			},
			{
				name = "Kanagawa Wave Transparent",
				colorscheme = "kanagawa",
				before = [[
					require("kanagawa").setup({
						theme = "Wave",
						transparent = true,
                    })
                ]],
			},

			{
				name = "Everforest Medium Dark",
				colorscheme = "everforest",
				before = [[
                    require("everforest").setup({
                        background = "medium",
                    })
                ]],
			},

			{
				name = "Fluoromachine Trans",
				colorscheme = "fluoromachine",
				before = [[
                    require("fluoromachine").setup({
                        glow = true,
                        theme = "fluoromachine",
                        transparent = true, 
                    })
                ]],
			},

			{
				name = "Lytmode",
				colorscheme = "lytmode",
				before = [[
                    require("lytmode").setup({})
                ]],
			},
			{
				name = "Lytmode Trans",
				colorscheme = "lytmode",
				before = [[
                    require("lytmode").setup({
                        transparent = true,
                    })
                ]],
			},
		},

		livePreview = true,
	},
	config = function(_, opts)
		require("themery").setup(opts)
	end,
}
