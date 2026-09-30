return {
	"neovim/nvim-lspconfig",
	-- Set up LspAttach and completion capabilities before the first client starts.
	lazy = false,
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
		-- config.lsp.attach uses Telescope's LSP pickers.
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local servers = require("config.lsp.servers")
		require("config.lsp.attach").setup()
		require("config.lsp.diagnostics").setup()

		-- Blink registers completion capabilities through vim.lsp.config("*").
		for name, definition in pairs(servers.definitions) do
			vim.lsp.config(name, definition)
		end

		require("mason-tool-installer").setup({
			ensure_installed = servers.ensure_installed(),
		})
		-- mason-lspconfig v2 enables Mason-installed servers automatically.
		require("mason-lspconfig").setup({ ensure_installed = {} })

		for _, name in ipairs(servers.system_servers()) do
			local definition = servers.definitions[name] or {}
			local binary = definition.cmd and definition.cmd[1] or name
			if vim.fn.executable(binary) == 1 then
				vim.lsp.enable(name)
			else
				vim.notify(
					("LSP %s: '%s' not found on $PATH; install it via your system package manager."):format(
						name,
						binary
					),
					vim.log.levels.WARN
				)
			end
		end
	end,
}
