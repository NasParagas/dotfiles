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

			-- get existing terminal or create a new one
			-- NOTE: direction is currently fixed NW
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
			--          -- TODO: no need
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
				local columns = vim.o.columns
				local lines = vim.o.lines
				-- cal 80% of the screen size
				local width = math.floor(columns * 0.8)
				local height = math.floor(lines * 0.8)
				-- Cal center the window
				local row = math.floor((lines - height) / 2)
				local col = math.floor((columns - width) / 2)

				term.float_opts.width = width
				term.float_opts.height = height
				term.float_opts.row = row
				term.float_opts.col = col

				term:toggle()
			end

			local function create_new_terminal()
				next_term_id = next_term_id + 1
				toggle_center(next_term_id)
			end

			-- keymap setting
			-- vim.keymap.set({ "n", "t" }, "<C-j>", toggle_bottom_float, { desc = "Bottom float terminal" })
			vim.keymap.set({ "n", "t" }, "<C-j>", function()
				toggle_center(1)
			end, { desc = "Center large terminal" })
			vim.keymap.set({ "n", "t" }, "<leader>tn", create_new_terminal, { desc = "Open new terminal" })
			-- Manage multiple terminals
			vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "Select running terminals" })
		end,
	},
}
