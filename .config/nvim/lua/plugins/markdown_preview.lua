return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	-- build = function()
	-- 	vim.fn["mkdp#util#install"]()
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
}
