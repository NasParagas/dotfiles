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

			-- get existing terminal or create a new one
			local function get_or_create_terminal(id)
				if not terminals[id] then
					terminals[id] = Terminal:new({
						count = id,
						direction = "float",
						float_opts = {
							border = "curved",
							anchor = "NW",
							winblend = 3,
						},
					})
				end
				return terminals[id]
			end

			-- =========================
			-- bottom float terminal
			-- =========================
			-- local bottom_float_term = Terminal:new({
			-- 	direction = "float",
			-- 	count = 1,
			-- 	float_opts = {
			-- 		border = "curved",
			-- 		anchor = "SW", -- placement?
			-- 		winblend = 3,
			-- 	},
			-- })
			-- local function toggle_bottom_float()
			-- 	local columns = vim.o.columns
			-- 	local lines = vim.o.lines
			-- 	local cmdh = vim.o.cmdheight
			-- 	local height = math.max(10, math.floor(lines * 0.3))
			-- 	local width = columns -- full width
			-- 	bottom_float_term.float_opts.height = height
			-- 	bottom_float_term.float_opts.row = lines - cmdh
			-- 	bottom_float_term.float_opts.col = 0
			-- 	bottom_float_term:toggle()
			-- end

			-- =============================
			-- Center large float terminal
			-- =============================
			local function toggle_center(id)
				local term = get_or_create_terminal(id)
				apply_center_size(term)
				term:toggle()
			end

			local function create_new_terminal()
				next_term_id = next_term_id + 1
				toggle_center(next_term_id)
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
							winblend = 3,
						},
						close_on_exit = false,
					})
				end
				local term = run_terminals[id]
				apply_center_size(term)
				term:toggle()
			end

			-- Terminal keymaps
			vim.keymap.set({ "n", "t" }, "<leader>tt", function()
				toggle_center(1)
			end, { desc = "[T]erminal [T]oggle" })
			vim.keymap.set({ "n", "t" }, "<leader>tn", create_new_terminal, { desc = "[T]erminal [N]ew" })
			vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "[T]erminal [S]elect" })

			-- Run keymaps
			vim.keymap.set("n", "<leader>rt", function() toggle_run("test",  101) end, { desc = "[R]un [T]est" })
			vim.keymap.set("n", "<leader>rw", function() toggle_run("watch", 102) end, { desc = "[R]un [W]atch" })
			vim.keymap.set("n", "<leader>rc", function() toggle_run("check", 103) end, { desc = "[R]un [C]heck" })
			vim.keymap.set("n", "<leader>rd", function() toggle_run("dev",   104) end, { desc = "[R]un [D]ev" })
		end,
	},
}
