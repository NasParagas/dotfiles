return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",

		opts = {
			top_down = false,
			render = "minimal", -- default, minimal, simple, compact
			timeout = 7000, -- Time until notification disappear
			background_colour = "#000000", -- transparent
		},

		config = function(_, opts)
			require("notify").setup(opts)
			-- replace
			vim.notify = require("notify")
		end,
	},
}
