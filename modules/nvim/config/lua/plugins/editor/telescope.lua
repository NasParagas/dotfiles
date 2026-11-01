local function picker(name, opts)
	return function()
		require("telescope.builtin")[name](opts)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	-- Also provides vim.ui.select (code actions and terminal selection).
	event = "VeryLazy",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	keys = {
		{ "<leader>sh", picker("help_tags"), desc = "[S]earch [H]elp" },
		{ "<leader>sk", picker("keymaps"), desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", picker("find_files"), desc = "[S]earch [F]iles" },
		{
			"<leader>sF",
			picker("find_files", { hidden = true, no_ignore = true, file_ignore_patterns = { "%.git/" } }),
			desc = "[S]earch [F]iles (Hidden)",
		},
		{ "<leader>ss", picker("builtin"), desc = "[S]earch [S]elect Telescope" },
		{ "<leader>sw", picker("grep_string"), desc = "[S]earch current [W]ord" },
		{ "<leader>sg", picker("live_grep"), desc = "[S]earch by [G]rep" },
		{
			"<leader>sG",
			picker("live_grep", {
				additional_args = function()
					return { "--hidden", "--no-ignore" }
				end,
				file_ignore_patterns = { "%.git/" },
			}),
			desc = "[S]earch by [G]rep (Hidden)",
		},
		{ "<leader>sd", picker("diagnostics"), desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", picker("resume"), desc = "[S]earch [R]esume" },
		{ "<leader>s.", picker("oldfiles"), desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", picker("buffers"), desc = "[ ] Find existing buffers" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
				)
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			picker("live_grep", { grep_open_files = true, prompt_title = "Live Grep in Open Files" }),
			desc = "[S]earch [/] in Open Files",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},
	},
	opts = { pickers = { find_files = { no_ignore = true } } },
	config = function(_, opts)
		opts.extensions = { ["ui-select"] = require("telescope.themes").get_dropdown() }
		require("telescope").setup(opts)
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
