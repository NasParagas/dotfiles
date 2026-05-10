local definitions = {
	pyright = {
		pythonVersion = "3.12",
	},
	rust_analyzer = {},
	neocmake = {},
	clangd = {
		cmd = {
			"clangd",
			"--clang-tidy",
			"--background-index",
			"--extra-arg=-std=c++23",
		},
		filetypes = {
			"c",
			"cpp",
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
}

local M = {
	definitions = definitions,
}

function M.ensure_installed()
	local ensure_installed = vim.tbl_keys(definitions)
	vim.list_extend(ensure_installed, {
		"stylua",
	})

	return ensure_installed
end

return M
