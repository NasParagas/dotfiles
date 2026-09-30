return {
	"NasParagas/random-key-tips.nvim",
	event = "VeryLazy",
	config = function()
		-- Start automatically when Neovim loads
		require("random-key-tips").setup({
			interval = 15000,
			-- auto_start = true,
		})
	end,
}
