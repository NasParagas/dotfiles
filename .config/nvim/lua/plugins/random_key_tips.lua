return {
	"NasParagas/random-key-tips.nvim",
	event = "VeryLazy",
	config = function()
		require("random-key-tips").setup({ interval = 15000 })
	end,
}
