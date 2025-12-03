return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	-- Denoを使ってビルドするコマンドを指定する必要があります
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({
			app = "browser", -- 'webview', 'browser', string or a function returning a string
			-- 必要ならここに他の設定
		})
		-- 便利なキーマッピング例
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	end,
}
