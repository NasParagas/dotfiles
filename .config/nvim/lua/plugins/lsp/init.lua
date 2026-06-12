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

			local function setup_server(server_name)
				local server = servers.definitions[server_name] or {}
				server.capabilities =
					vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end

			require("mason-tool-installer").setup({
				ensure_installed = servers.ensure_installed(),
			})

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						setup_server(server_name)
					end,
				},
			})

			-- Servers installed outside Mason (e.g. clangd from apt on Linux
			-- aarch64, which Mason cannot provide). Configure them when the
			-- binary is present, otherwise hint how to install it.
			for _, server_name in ipairs(servers.system_servers()) do
				local definition = servers.definitions[server_name] or {}
				local binary = definition.cmd and definition.cmd[1] or server_name
				if vim.fn.executable(binary) == 1 then
					setup_server(server_name)
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
