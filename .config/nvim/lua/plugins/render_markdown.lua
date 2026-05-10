return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	event = "BufEnter",
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		latex = {
			enabled = true,
			render_modes = false,
			converter = { "utftex", "latex2text" },
			highlight = "RenderMarkdownMath",
			position = "center",
			top_pad = 0,
			bottom_pad = 0,
		},
	},
	config = function(opts)
		require("render-markdown").setup(opts)
	end,
}
