----- list setting -----
-- Continue list markers when pressing Enter in insert mode or o/O.
vim.opt_local.formatoptions:append("r")
vim.opt_local.formatoptions:append("o")
vim.opt_local.comments = "b:-,b:*,b:+,n:>"

-- But don't continue when pressing S-Enter.
vim.keymap.set("i", "<S-Enter>", "<CR><Esc>S", { buffer = true, remap = false })

-- On Enter, if the line is an empty list marker (e.g. "- ", "* ", "1. ",
-- "- [ ] "), remove the marker and end the list instead of continuing it.
vim.keymap.set("i", "<CR>", function()
	local line = vim.api.nvim_get_current_line()
	local empty_marker = line:match("^%s*[-*+]%s$") -- "- " / "* " / "+ "
		or line:match("^%s*[-*+]%s%[.%]%s$") -- "- [ ] " task list
		or line:match("^%s*%d+%.%s$") -- "1. " ordered list
	if empty_marker then
		vim.api.nvim_set_current_line("")
		vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), 0 })
		return
	end
	-- Otherwise fall back to nvim-autopairs' Enter handling (pair expansion,
	-- e.g. splitting ```|``` into 3 lines), or plain Enter if unavailable.
	local ok, npairs = pcall(require, "nvim-autopairs")
	if ok then
		vim.api.nvim_feedkeys(npairs.autopairs_cr(), "n", false)
		return
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end, { buffer = true, desc = "Markdown: end list on empty item, else newline" })

-- Use 2-space indentation
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
-- Make BS remove indentation in 2-space
vim.opt_local.softtabstop = 2

-- .md へのリンクは、リンク先がまだなくても新しいバッファとして開く。
-- ディレクトリは保存時に lua/config/autocmds.lua の BufWritePre が作るので、ここでは作らない。
vim.keymap.set("n", "gf", function()
	local link = vim.fn.expand("<cfile>")

	if link == "" then
		return
	end

	if not link:match("%.md$") then
		vim.cmd("normal! gf")
		return
	end

	-- 相対パスは、カーソル位置ではなく今のファイルのディレクトリを基準にする
	local target_path = link
	if not vim.startswith(link, "/") then
		target_path = vim.fn.expand("%:p:h") .. "/" .. link
	end

	vim.cmd("edit " .. vim.fn.fnameescape(target_path))
end, { buffer = true, desc = "Follow Markdown link (open it even if it does not exist yet)" })
