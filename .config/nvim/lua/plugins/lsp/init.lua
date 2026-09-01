local attach = require("config.lsp.attach")
local diagnostics = require("config.lsp.diagnostics")
local servers = require("config.lsp.servers")

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			attach.setup()
			diagnostics.setup()

			-- Completion capabilities need no manual merging: blink.cmp
			-- registers its own via vim.lsp.config("*").
			for server_name, definition in pairs(servers.definitions) do
				vim.lsp.config(server_name, definition)
			end

			require("mason-tool-installer").setup({
				ensure_installed = servers.ensure_installed(),
			})

			-- mason-lspconfig v2 enables every Mason-installed server through
			-- vim.lsp.enable() by itself (the v1 `handlers` option is gone).
			require("mason-lspconfig").setup({
				ensure_installed = {},
			})

			-- Servers installed outside Mason (e.g. clangd from apt on Linux
			-- aarch64, which Mason cannot provide). Enable them when the
			-- binary is present, otherwise hint how to install it.
			for _, server_name in ipairs(servers.system_servers()) do
				local definition = servers.definitions[server_name] or {}
				local binary = definition.cmd and definition.cmd[1] or server_name
				if vim.fn.executable(binary) == 1 then
					vim.lsp.enable(server_name)
				else
					vim.notify(
						("LSP %s: '%s' not found on $PATH; install it via your system package manager.")
							:format(server_name, binary),
						vim.log.levels.WARN
					)
				end
			end
		end,
	},
}
