return {
	"rhysd/git-messenger.vim",
	cmd = { "GitMessenger", "GitMessengerClose" },
	init = function()
		vim.g.git_messenger_no_default_mappings = true
	end,
	keys = { { "<leader>gm", "<cmd>GitMessenger<CR>", desc = "Git commit message" } },
}
