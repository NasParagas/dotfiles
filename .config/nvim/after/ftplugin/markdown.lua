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
	-- Otherwise fall back to the default Enter (keeps list continuation via 'r').
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end, { buffer = true, desc = "Markdown: end list on empty item, else newline" })

-- Use 2-space indentation
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
-- Make BS remove indentation in 2-space
vim.opt_local.softtabstop = 2

-- Make file if not exist under cursor md file path
vim.keymap.set("n", "gf", function()
	-- Get file path under cursor
	local filepath_under_cursor = vim.fn.expand("<cfile>")

	if filepath_under_cursor == "" then
		return
	end

	if filepath_under_cursor:match("%.md$") then
		-- Get the dir of the current md file.
		local current_dir = vim.fn.expand("%:p:h")

		-- Built the target file path.
		local target_path = current_dir .. "/" .. filepath_under_cursor

		-- Make dir if not exists.
		local target_dir = vim.fn.fnamemodify(target_path, ":h")
		if vim.fn.isdirectory(target_dir) == 0 then
			vim.fn.mkdir(target_dir, "p") -- == mkdir -p target_dir
		end

		-- Execute ":e <target_path>"
		vim.cmd("edit " .. vim.fn.fnameescape(target_path))
	else
		-- Do normal gf if isn't .md
		vim.cmd("normal! gf")
	end
end, { buffer = true, desc = "Follow Markdown link (and create it if not exists)" })
