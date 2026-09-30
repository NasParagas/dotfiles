local M = {}

local WIDTH = 20
local BAR_PATTERN = "%s*%[[#%-]*%]%s*%d+%%"

-- Render the first current/total expression, replacing any existing bar.
function M.render(text)
	local base = text:gsub(BAR_PATTERN, "")
	local _, last, current, total = base:find("(%d+)%s*/%s*(%d+)")
	if not current then
		return nil, "No `current/total` pattern found in the selection"
	end

	current, total = tonumber(current), tonumber(total)
	if total == 0 then
		return nil, "Total (the denominator) must not be zero"
	end

	local ratio = math.min(math.max(current / total, 0), 1)
	local filled = math.floor(ratio * WIDTH + 0.5)
	local bar = string.rep("#", filled) .. string.rep("-", WIDTH - filled)
	local rendered = string.format("[%s] %d%%", bar, math.floor(ratio * 100 + 0.5))
	return base:sub(1, last) .. " " .. rendered .. base:sub(last + 1)
end

return M
