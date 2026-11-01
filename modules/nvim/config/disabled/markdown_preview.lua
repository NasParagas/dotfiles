return {
	"iamcco/markdown-preview.nvim",
	event = "BufEnter",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_images_path = vim.fn.expand("%:p:h")
	end,
	ft = { "markdown" },
	keys = {
		{
			"<leader>MP",
			"<cmd>MarkdownPreview<cr>",
			desc = "Markdown Preview",
			ft = "markdown", -- markdownファイルの時だけ有効
		},
	},
}
