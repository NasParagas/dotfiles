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

-- file setting
-- all
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- C/C++
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.autoindent = true
		vim.opt_local.cindent = true -- C/C++ の構文に沿ったインデント支援
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
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		-- バックスペースキーでスペース2つ分を一度に消せるようにする（あたかもタブのように振る舞う）
		vim.opt_local.softtabstop = 2
		vim.keymap.set("i", "<S-Enter>", "<CR><Esc>S", { buffer = true, remap = false })
	end,
})
