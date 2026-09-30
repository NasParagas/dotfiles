local M = {}

function M.setup()
	local highlight_method = vim.lsp.protocol.Methods.textDocument_documentHighlight
	local highlight_group = vim.api.nvim_create_augroup("dotfiles-lsp-highlight", { clear = true })
	local attach_group = vim.api.nvim_create_augroup("dotfiles-lsp-attach", { clear = true })

	vim.api.nvim_create_autocmd("LspDetach", {
		group = attach_group,
		callback = function(event)
			-- Detach fires before the client is removed from the buffer.
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(event.buf) then
					return
				end
				if #vim.lsp.get_clients({ bufnr = event.buf, method = highlight_method }) == 0 then
					vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
					vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = attach_group,
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
			map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
			map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
			map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method(highlight_method, event.buf) then
				-- Multiple clients can attach to one buffer; install only one set.
				vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_group,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_group,
					callback = vim.lsp.buf.clear_references,
				})
			end

			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map("<leader>lh", function()
					local filter = { bufnr = event.buf }
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
				end, "[L]SP Toggle Inlay [H]ints")
			end
		end,
	})
end

return M
