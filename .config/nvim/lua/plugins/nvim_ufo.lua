return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufRead",
	keys = {
		-- すべて折りたたむ / すべて開く のショートカットを作っておくと便利
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "Open all folds",
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close all folds",
		},
	},
	config = function()
		-- Neovim標準の折りたたみ機能をufoに任せる設定
		vim.o.foldcolumn = "1" -- 左端に折りたたみ状態を表示する列を作る（0なら非表示）
		vim.o.foldlevel = 99 -- 起動時に勝手に折りたたまないようにする
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
}
