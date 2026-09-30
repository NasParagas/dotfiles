return {
	"brianhuster/live-preview.nvim",
	cmd = "LivePreview",
	dependencies = { "nvim-telescope/telescope.nvim" },
	main = "livepreview",
	opts = { picker = "telescope" },
}
