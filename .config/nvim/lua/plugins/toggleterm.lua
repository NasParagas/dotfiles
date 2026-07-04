return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			shell = "/bin/bash",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal

			-- =============================
			-- Center float terminals (multi-instance, IDs 1-99)
			-- =============================
			local terminals = {}
			local next_term_id = 1

			local function apply_center_size(term)
				local columns = vim.o.columns
				local lines = vim.o.lines
				local width = math.floor(columns * 0.8)
				local height = math.floor(lines * 0.8)
				term.float_opts.width = width
				term.float_opts.height = height
				term.float_opts.row = math.floor((lines - height) / 2)
				term.float_opts.col = math.floor((columns - width) / 2)
			end

			local function get_or_create_center(id)
				if not terminals[id] then
					terminals[id] = Terminal:new({
						count = id,
						direction = "float",
						float_opts = {
							border = "curved",
							anchor = "NW",
							winblend = 0,
						},
					})
				end
				return terminals[id]
			end

			local function toggle_center(id)
				local term = get_or_create_center(id)
				apply_center_size(term)
				term:toggle()
			end

			local function create_new_terminal()
				next_term_id = next_term_id + 1
				toggle_center(next_term_id)
			end

			-- =============================
			-- Single-instance layout terminals (IDs 201-203)
			-- =============================
			local layout_terminals = {}

			local function toggle_fullscreen()
				if not layout_terminals.full then
					layout_terminals.full = Terminal:new({
						count = 201,
						direction = "float",
						float_opts = {
							border = "none",
							anchor = "NW",
							winblend = 0,
							width = vim.o.columns,
							height = vim.o.lines,
							row = 0,
							col = 0,
						},
					})
				end
				local term = layout_terminals.full
				term.float_opts.width = vim.o.columns
				term.float_opts.height = vim.o.lines
				term:toggle()
			end

			local function toggle_vertical()
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

			local function toggle_horizontal()
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

			-- =============================
			-- Run terminals (IDs 101-104)
			-- =============================
			local run_terminals = {}

			local function toggle_run(recipe, id)
				if not run_terminals[id] then
					run_terminals[id] = Terminal:new({
						cmd = "just " .. recipe,
						count = id,
						direction = "float",
						float_opts = {
							border = "curved",
							anchor = "NW",
							winblend = 0,
						},
						close_on_exit = false,
					})
				end
				local term = run_terminals[id]
				apply_center_size(term)
				term:toggle()
			end

			-- =============================
			-- Delete terminal
			-- =============================
			local function delete_terminal()
				local all = require("toggleterm.terminal").get_all(true)
				if #all == 0 then
					vim.notify("No terminals open", vim.log.levels.INFO)
					return
				end
				vim.ui.select(all, {
					prompt = "Delete terminal: ",
					format_item = function(term)
						return term.id .. ": " .. term:_display_name()
					end,
				}, function(term)
					if not term then
						return
					end
					term:shutdown()
					for id, t in pairs(terminals) do
						if t == term then
							terminals[id] = nil
							break
						end
					end
					for id, t in pairs(run_terminals) do
						if t == term then
							run_terminals[id] = nil
							break
						end
					end
					for key, t in pairs(layout_terminals) do
						if t == term then
							layout_terminals[key] = nil
							break
						end
					end
				end)
			end

			-- Terminal keymaps
			vim.keymap.set("n", "<leader>tt", function()
				toggle_center(1)
			end, { desc = "[T]erminal [T]oggle" })
			vim.keymap.set("n", "<leader>tn", create_new_terminal, { desc = "[T]erminal [N]ew" })
			vim.keymap.set("n", "<leader>tf", toggle_fullscreen, { desc = "[T]erminal [F]ullscreen" })
			vim.keymap.set("n", "<leader>tv", toggle_vertical, { desc = "[T]erminal [V]ertical" })
			vim.keymap.set("n", "<leader>th", toggle_horizontal, { desc = "[T]erminal [H]orizontal" })
			vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "[T]erminal [S]elect" })
			vim.keymap.set("n", "<leader>td", delete_terminal, { desc = "[T]erminal [D]elete" })

			-- Run keymaps
			vim.keymap.set("n", "<leader>rt", function()
				toggle_run("test", 101)
			end, { desc = "[R]un [T]est" })
			vim.keymap.set("n", "<leader>rw", function()
				toggle_run("watch", 102)
			end, { desc = "[R]un [W]atch" })
			vim.keymap.set("n", "<leader>rc", function()
				toggle_run("check", 103)
			end, { desc = "[R]un [C]heck" })
			vim.keymap.set("n", "<leader>rd", function()
				toggle_run("dev", 104)
			end, { desc = "[R]un [D]ev" })
		end,
	},
}
