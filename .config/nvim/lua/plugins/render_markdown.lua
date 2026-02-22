return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	event = "BufEnter",
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	config = function(opts)
		require("render-markdown").setup(opts)
	end,
}
