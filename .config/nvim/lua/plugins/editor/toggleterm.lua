return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = {
		"ToggleTerm",
		"TermSelect",
		"TermExec",
		"ToggleTermToggleAll",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualLines",
		"ToggleTermSendVisualSelection",
		"ToggleTermSetName",
	},
	-- Always use bash, preferring the one on PATH (Homebrew bash over /bin/bash 3.2 on macOS).
	opts = function()
		local bash = vim.fn.exepath("bash")
		return { shell = bash ~= "" and bash or "/bin/bash" }
	end,
	keys = {
		{
			"<leader>tt",
			function()
				require("custom.terminal").toggle_center(1)
			end,
			desc = "[T]erminal [T]oggle",
		},
		{
			"<leader>tn",
			function()
				require("custom.terminal").new()
			end,
			desc = "[T]erminal [N]ew",
		},
		{
			"<leader>tf",
			function()
				require("custom.terminal").toggle_fullscreen()
			end,
			desc = "[T]erminal [F]ullscreen",
		},
		{
			"<leader>tv",
			function()
				require("custom.terminal").toggle_vertical()
			end,
			desc = "[T]erminal [V]ertical",
		},
		{
			"<leader>th",
			function()
				require("custom.terminal").toggle_horizontal()
			end,
			desc = "[T]erminal [H]orizontal",
		},
		{ "<leader>ts", "<cmd>TermSelect<CR>", desc = "[T]erminal [S]elect" },
		{
			"<leader>td",
			function()
				require("custom.terminal").delete()
			end,
			desc = "[T]erminal [D]elete",
		},
		{
			"<leader>rt",
			function()
				require("custom.terminal").toggle_run("test", 101)
			end,
			desc = "[R]un [T]est",
		},
		{
			"<leader>rw",
			function()
				require("custom.terminal").toggle_run("watch", 102)
			end,
			desc = "[R]un [W]atch",
		},
		{
			"<leader>rc",
			function()
				require("custom.terminal").toggle_run("check", 103)
			end,
			desc = "[R]un [C]heck",
		},
		{
			"<leader>rd",
			function()
				require("custom.terminal").toggle_run("dev", 104)
			end,
			desc = "[R]un [D]ev",
		},
	},
}
