-- [[ Basic Autocommands ]]
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

-- C/C++
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.bo.expandtab = false -- タブ文字を挿入
		vim.bo.tabstop = 4 -- タブ表示幅
		vim.bo.shiftwidth = 4 -- >>, << のステップ
		vim.bo.autoindent = true -- 改行時に直前行のインデントをコピー
		vim.bo.cindent = true -- C/C++ の構文に沿ったインデント支援
	end,
})

-- markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- insertモードでのenterらしい?
		vim.opt_local.formatoptions:append("r")
		-- normalモードでのoとO
		vim.opt_local.formatoptions:append("o")
		-- b=blank required
		-- ` -`で始まる行について行うという設定...のはず
		vim.opt_local.comments = "b:-,b:*,b:+,n:>"
		-- タブ文字の幅をスペース2つ分に見せる
		vim.opt_local.tabstop = 2

		-- インデント（>> や <<）の幅をスペース2つ分にする
		vim.opt_local.shiftwidth = 2

		-- Tabキーを押した時に、タブ文字ではなくスペースを挿入する
		vim.opt_local.expandtab = true

		-- バックスペースキーでスペース2つ分を一度に消せるようにする（あたかもタブのように振る舞う）
		vim.opt_local.softtabstop = 2
	end,
})
