-- ~/.config/nvim/lua/plugins/none_ls.lua
return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- C/C++ のフォーマット
					null_ls.builtins.formatting.clang_format.with({
						extra_args = { "--style=file" }, -- プロジェクトの .clang-format を使う
					}),
				},

				-- ここに on_attach を入れる
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						-- ✅ augroup を先に作成（IDが返る）
						local aug = vim.api.nvim_create_augroup("_null_ls_format_on_save", { clear = true })

						-- 既存を明示的に消したい場合は group=aug を渡す（ID使用）
						-- vim.api.nvim_clear_autocmds({ group = aug, buffer = bufnr })

						vim.api.nvim_create_autocmd("BufWritePre", {
							group = aug,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									bufnr = bufnr,
									async = false,
									timeout_ms = 3000,
									-- 🚩 フォーマッタを null-ls に限定（none-lsのクライアント名は "null-ls" のまま）
									filter = function(fmt_client)
										return fmt_client.name == "null-ls"
									end,
								})
							end,
						})
					end
				end,
			})
		end,
	},
}
