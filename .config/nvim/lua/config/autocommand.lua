--- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- C/C++ のときはタブ文字を使い、見た目の幅は 4
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.bo.expandtab = false -- タブ文字を挿入
		vim.bo.tabstop = 4 -- タブ表示幅
		vim.bo.shiftwidth = 4 -- >>, << のステップ
		vim.bo.softtabstop = 0 -- <BS> でタブを壊さないなら 0 推奨（好みで 4 でも可）
		vim.bo.autoindent = true -- 改行時に直前行のインデントをコピー
		vim.bo.cindent = true -- C/C++ の構文に沿ったインデント支援
		-- 必要なら cindent の挙動調整（例）
		-- vim.bo.cinoptions = "l1,g0,t0"
	end,
})
