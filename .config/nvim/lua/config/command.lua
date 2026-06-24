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

--------------
-- Render a progress bar from a selected "current/total" expression (e.g. 10/200 -> 5%)
-- ------------
local PROGRESS_BAR_WIDTH = 10

local function build_progress_bar(text)
	-- Front number is the current value (numerator), back number is the total (denominator)
	local current, total = text:match("(%d+)%s*/%s*(%d+)")
	if not current then
		return nil, "No `current/total` pattern found in the selection"
	end

	current, total = tonumber(current), tonumber(total)
	if total == 0 then
		return nil, "Total (the first number) must not be zero"
	end

	local ratio = math.min(math.max(current / total, 0), 1)
	local filled = math.floor(ratio * PROGRESS_BAR_WIDTH + 0.5)
	local bar = string.rep("█", filled) .. string.rep("░", PROGRESS_BAR_WIDTH - filled)

	return string.format("[%s] %d%%", bar, math.floor(ratio * 100 + 0.5))
end

vim.api.nvim_create_user_command("BuildProgressBar", function()
	-- Operate on the most recent charwise visual selection (single line)
	local srow = vim.fn.line("'<")
	local scol = vim.fn.col("'<")
	local ecol = vim.fn.col("'>")

	local selection = vim.fn.getline(srow):sub(scol, ecol)
	local bar, err = build_progress_bar(selection)
	if not bar then
		vim.notify("ProgressBar: " .. err, vim.log.levels.WARN)
		return
	end

	-- Append the bar after the original selection, keeping the source text
	vim.api.nvim_buf_set_text(0, srow - 1, scol - 1, srow - 1, ecol, { selection .. " " .. bar })
end, { range = true, desc = "Render a progress bar from a selected current/total value" })

-----------
-- 現在開いているファイルの絶対パスをyank
-- --------
-- vim.api.nvim_create_user_command("GetPWDCurrentBuf", function()
--     local pwd = vim.fn.expand("%:p")
-- )
