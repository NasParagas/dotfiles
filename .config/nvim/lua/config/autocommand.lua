-----
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

----- file setting -----
-- all
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- C/C++
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.autoindent = true
		vim.opt_local.cindent = true
	end,
})

-- markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Enter in insert mode
		vim.opt_local.formatoptions:append("r")
		-- "o" and "O" in normal mode
		vim.opt_local.formatoptions:append("o")
		-- b=blank required
		-- ` -`で始まる行について行うという設定...のはず
		vim.opt_local.comments = "b:-,b:*,b:+,n:>"
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		-- バックスペースキーでスペース2つ分を一度に消せるようにする
		vim.opt_local.softtabstop = 2
		vim.keymap.set("i", "<S-Enter>", "<CR><Esc>S", { buffer = true, remap = false })

		----- normal mode の gf にファイルへ移動する機能だけでなく新規作成機能も追加(mdのみ) -----
		vim.keymap.set("n", "gf", function()
			-- get file path under cursor
			local filepath_under_cursor = vim.fn.expand("<cfile>")

			-- filepath が空(=カーソル下がfilepathでない)なら何もしない
			if filepath_under_cursor == "" then
				return
			end

			-- filepath が .md で終わる場合
			if filepath_under_cursor:match("%.md$") then
				-- 開いているファイルの絶対パス (TODO: %":p:h" とは)
				local current_dir = vim.fn.expand("%:p:h")

				-- 作成したいファイル
				local target_path = current_dir .. "/" .. filepath_under_cursor

				-- 作成したいファイルが新しいディレクトリだった場合、ディレクトリも作成
				local target_dir = vim.fn.fnamemodify(target_path, ":h")
				if vim.fn.isdirectory(target_dir) == 0 then
					vim.fn.mkdir(target_dir, "p") -- = mkdir -p target_dir
				end

				-- ファイルを開く (ファイルがない時は、新規の空bufferとして開く)
				vim.cmd("edit " .. vim.fn.fnameescape(target_path))
			else
				-- .md 以外は標準のgfに委ねる
				vim.cmd("normal! gf")
			end
		end, { buffer = true, desc = "Follow Markdown link (and create it if not exists)" })
	end,
})
