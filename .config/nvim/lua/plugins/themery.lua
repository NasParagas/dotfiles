return {
	"zaldih/themery.nvim",
	lazy = false,
	opts = {
		themes = {
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
				name = "Tokyonight Night Transparent",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "night",
						transparent = true,
            styles = {
              sidebars = "transparent",
              floats = "transparent",
            },
					})
				]],
			},
			{
				name = "Tokyonight Day Transparent",
				colorscheme = "tokyonight",
				before = [[
					require("tokyonight").setup({
						style = "day",
						transparent = true,
            styles = {
              sidebars = "transparent",
              floats = "transparent",
            },
					})
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
				name = "Kanagawa Wave Transparent",
				colorscheme = "kanagawa",
				before = [[
					require("kanagawa").setup({
						theme = "Wave",
						transparent = true,
            colors = {
              theme = {
                all = {
                  ui = {
                    bg_gutter = "none"
                  }
                }
              }
            },
        
            -- もしフローティングウィンドウの枠線なども透明にしたい場合は以下も推奨
            overrides = function(colors)
              return {
                -- 必要に応じて追加
                NormalFloat = { bg = "none" },
                FloatBorder = { bg = "none" },
                FloatTitle = { bg = "none" },
              }
            end,
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
