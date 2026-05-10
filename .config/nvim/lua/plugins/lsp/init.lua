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

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason-tool-installer").setup({
				ensure_installed = servers.ensure_installed(),
			})

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers.definitions[server_name] or {}
						server.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
