local Terminal = require("toggleterm.terminal").Terminal
local M = {}

-- Separate ID ranges: interactive 1-99, just recipes 101-104, layouts 201-203.
local terminals = {}
local layout_terminals = {}
local run_terminals = {}

local function apply_center_size(term)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	term.float_opts.width = width
	term.float_opts.height = height
	term.float_opts.row = math.floor((vim.o.lines - height) / 2)
	term.float_opts.col = math.floor((vim.o.columns - width) / 2)
end

function M.toggle_center(id)
	if not terminals[id] then
		terminals[id] = Terminal:new({
			count = id,
			direction = "float",
			float_opts = { border = "curved", anchor = "NW", winblend = 0 },
		})
	end
	local term = terminals[id]
	apply_center_size(term)
	term:toggle()
end

function M.new()
	for id = 2, 99 do
		if not terminals[id] then
			M.toggle_center(id)
			return
		end
	end
	vim.notify("All interactive terminal IDs (2-99) are in use", vim.log.levels.WARN)
end

function M.toggle_fullscreen()
	if not layout_terminals.full then
		layout_terminals.full = Terminal:new({
			count = 201,
			direction = "float",
			float_opts = { border = "none", anchor = "NW", winblend = 0, row = 0, col = 0 },
		})
	end
	local term = layout_terminals.full
	term.float_opts.width = vim.o.columns
	term.float_opts.height = vim.o.lines
	term:toggle()
end

function M.toggle_vertical()
	if not layout_terminals.vert then
		layout_terminals.vert = Terminal:new({
			count = 202,
			direction = "vertical",
			on_open = function()
				vim.cmd("wincmd L")
				vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.25))
			end,
		})
	end
	layout_terminals.vert:toggle()
end

function M.toggle_horizontal()
	if not layout_terminals.horiz then
		layout_terminals.horiz = Terminal:new({
			count = 203,
			direction = "horizontal",
			on_open = function()
				vim.cmd("wincmd J")
				vim.cmd("resize 15")
			end,
		})
	end
	layout_terminals.horiz:toggle()
end

function M.toggle_run(recipe, id)
	if not run_terminals[id] then
		run_terminals[id] = Terminal:new({
			cmd = "just " .. recipe,
			count = id,
			direction = "float",
			float_opts = { border = "curved", anchor = "NW", winblend = 0 },
			close_on_exit = false,
		})
	end
	local term = run_terminals[id]
	apply_center_size(term)
	term:toggle()
end

function M.delete()
	local all = require("toggleterm.terminal").get_all(true)
	if #all == 0 then
		vim.notify("No terminals open", vim.log.levels.INFO)
		return
	end
	vim.ui.select(all, {
		prompt = "Delete terminal: ",
		format_item = function(term)
			return term.id .. ": " .. (term.display_name or term.name or "terminal")
		end,
	}, function(term)
		if not term then
			return
		end
		term:shutdown()
		for _, cache in ipairs({ terminals, run_terminals, layout_terminals }) do
			for id, cached in pairs(cache) do
				if cached == term then
					cache[id] = nil
				end
			end
		end
	end)
end

return M
