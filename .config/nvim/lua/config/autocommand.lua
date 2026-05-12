-- Highlight text after yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Create HTML details/summary tag
vim.api.nvim_create_user_command("InsertDetails", function()
	-- Define the standard HTML details/summary lines
	local lines = {
		"<details>",
		"  <summary> </summary>",
		"  ",
		"</details>",
	}

	-- Get the current cursor position (row is 1-indexed)
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	-- Insert the lines immediately below the current cursor
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)

	-- Move the cursor into the <summary> tag for quick editing
	vim.api.nvim_win_set_cursor(0, { row + 2, 11 })
end, { desc = "Insert HTML details and summary tags" })

----- file setting -----
-- all
-- tab → spave
vim.opt.expandtab = true
-- tabの幅をspace 4つに
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.smartindent = true

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
		----- リスト関連の設定 -----
		-- "- "とかでenterを押した時、下の行でも"- "と自動入力
		vim.opt_local.formatoptions:append("r")
		vim.opt_local.formatoptions:append("o")
		vim.opt_local.comments = "b:-,b:*,b:+,n:>"
		-- shift enter でリスト化しない
		vim.keymap.set("i", "<S-Enter>", "<CR><Esc>S", { buffer = true, remap = false })

		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		-- バックスペースキーでスペース2つ分を一度に消せるようにする
		vim.opt_local.softtabstop = 2

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
				-- 開いているファイルの絶対パス (%...現在のファイル名(つまり開いているmd), :p...絶対パスへ変換..., :h...末尾(ファイル名)を取り除く)
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
