----------
--- Create HTML details/summary tag
----------
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

vim.api.nvim_create_user_command("BuildProgressBar", function(args)
	-- Work on the whole line of the selection so selecting just the
	-- `current/total` value is enough; any existing bar on the line is updated.
	local srow = args.line1
	local line = vim.fn.getline(srow)

	local newline, err = require("custom.progress_bar").render(line)
	if not newline then
		vim.notify("ProgressBar: " .. err, vim.log.levels.WARN)
		return
	end

	-- Rewrite the line with the bar inserted right after the value.
	-- Any existing bar in the line was already stripped, so re-running updates it.
	vim.fn.setline(srow, newline)
end, { range = true, desc = "Render a progress bar from a selected current/total value" })
