return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "codedark",
			icons_enabled = true,
			section_separators = "",
			component_separators = "",
		},
	},
}
