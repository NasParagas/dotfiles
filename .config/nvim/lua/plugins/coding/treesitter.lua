return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Parsers not bundled with nvim-treesitter. Registered on TSUpdate so
		-- install() and :TSUpdate both see them.
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").veryl = {
					install_info = {
						url = "https://github.com/veryl-lang/tree-sitter-veryl",
						queries = "queries",
					},
				}
			end,
		})

		-- One parser -> filetypes table controls installation and highlighting.
		-- Empty lists are parsers used only through language injections.
		local languages = {
			bash = { "sh" },
			c = { "c" },
			cpp = { "cpp", "metal", "cuda", "cu", "cuh" },
			cmake = { "cmake" },
			css = { "css" },
			diff = { "diff" },
			html = { "html" },
			javascript = { "javascript" },
			latex = { "tex" },
			lua = { "lua" },
			luadoc = {},
			markdown = { "markdown" },
			markdown_inline = {},
			python = { "python" },
			query = { "query" },
			typescript = { "typescript" },
			-- .veryl files keep veryl.vim's syntax; the parser is for injections.
			veryl = {},
			vim = { "vim" },
			vimdoc = { "help" },
		}
		local parsers = vim.tbl_keys(languages)
		table.sort(parsers)
		require("nvim-treesitter").install(parsers)

		local filetypes = {}
		for _, parser in ipairs(parsers) do
			local types = languages[parser]
			if #types > 0 then
				-- Metal and CUDA use the C++ parser as a syntax approximation.
				vim.treesitter.language.register(parser, types)
				vim.list_extend(filetypes, types)
			end
		end
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("dotfiles-treesitter", { clear = true }),
			pattern = filetypes,
			callback = function(args)
				-- Parsers may still be installing on the first launch.
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
