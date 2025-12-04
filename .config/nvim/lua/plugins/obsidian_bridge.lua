return {
	"oflisback/obsidian-bridge.nvim",
	opts = {
		-- your config here
		scroll_sync = true,
	},
	event = {
		"BufReadPre *.md",
		"BufNewFile *.md",
	},
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
