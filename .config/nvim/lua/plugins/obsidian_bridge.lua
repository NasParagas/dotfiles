return {
	"oflisback/obsidian-bridge.nvim",
	event = "VeryLazy",
	opts = {
		-- your config here
		scroll_sync = true,
	},
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
