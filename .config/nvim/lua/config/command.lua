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

-- Pattern matching an already rendered bar, e.g. " [████░░░░░░] 50%"
local PROGRESS_BAR_PATTERN = "%s*%[[█░]*%]%s*%d+%%"

local function build_progress_bar(text)
	-- Drop any previously rendered bar so re-running updates instead of appending
	local base = text:gsub(PROGRESS_BAR_PATTERN, "")

	-- Front number is the current value (numerator), back number is the total (denominator).
	-- `mend` is the byte index of the last digit, so we can insert the bar right after it.
	local _, mend, current, total = base:find("(%d+)%s*/%s*(%d+)")
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
	local rendered = string.format("[%s] %d%%", bar, math.floor(ratio * 100 + 0.5))

	-- Insert the bar right after the `current/total` value, keeping any trailing text
	return base:sub(1, mend) .. " " .. rendered .. base:sub(mend + 1)
end

vim.api.nvim_create_user_command("BuildProgressBar", function()
	-- Work on the whole line of the selection so selecting just the
	-- `current/total` value is enough; any existing bar on the line is updated.
	local srow = vim.fn.line("'<")
	local line = vim.fn.getline(srow)

	local newline, err = build_progress_bar(line)
	if not newline then
		vim.notify("ProgressBar: " .. err, vim.log.levels.WARN)
		return
	end

	-- Rewrite the line with the bar inserted right after the value.
	-- Any existing bar in the line was already stripped, so re-running updates it.
	vim.fn.setline(srow, newline)
end, { range = true, desc = "Render a progress bar from a selected current/total value" })

-----------
-- 現在開いているファイルの絶対パスをyank
-- --------
-- vim.api.nvim_create_user_command("GetPWDCurrentBuf", function()
--     local pwd = vim.fn.expand("%:p")
-- )
