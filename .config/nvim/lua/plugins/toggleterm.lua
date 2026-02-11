return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			shell = "/bin/bash",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal

			-- 1つのインスタンスを再利用する（毎回 new しない）
			local bottom_float_term = Terminal:new({
				direction = "float",
				float_opts = {
					border = "rounded",
					-- 'relative' は toggleterm が内部で設定するが、明示すると安心
					relative = "editor",
					-- Neovim 0.9+ 推奨: 左下基準(南西)で位置決めできる
					anchor = "SW",
				},
			})

			-- 動的に現在の画面サイズからフロート位置・サイズを更新してトグル
			local function toggle_bottom_float()
				local columns = vim.o.columns
				local lines = vim.o.lines
				local cmdh = vim.o.cmdheight
				local height = math.max(10, math.floor(lines * 0.3)) -- 画面高の30%（最低10）
				local width = columns -- 全幅
				bottom_float_term.float_opts.width = width
				bottom_float_term.float_opts.height = height
				bottom_float_term.float_opts.row = lines - cmdh -- 下端に合わせる
				bottom_float_term.float_opts.col = 0
				bottom_float_term:toggle()
			end
			-- 好きなキーに割り当て（例: Ctrl-/ にしたいなら <C-/>）
			vim.keymap.set({ "n", "t" }, "<C-j>", toggle_bottom_float, { desc = "Bottom float terminal" })

			-- 	local function split_terminal_vertical()
			-- 		vim.cmd("vsplit")
			-- 		local shell = vim.env.SHELL
			-- 		vim.cmd("terminal " .. shell)
			--
			-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
			-- 	end
			-- 	vim.keymap.set({ "t", "n" }, "<C-S-e>", split_terminal_vertical, { desc = "垂直分割" })
		end,
	},
}
