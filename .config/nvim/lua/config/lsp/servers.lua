-- Resolve the Python interpreter for a project without activating the venv.
-- Ask uv which interpreter it would use (it discovers the project's ".venv"),
-- and silently fall back to system python when this isn't a uv/Python project
-- (no uv, no .venv, or uv errors out).
local function get_python_path(root_dir)
	local fallback = vim.fn.exepath("python3")

	if vim.fn.executable("uv") ~= 1 or not root_dir then
		return fallback
	end

	local out = vim.fn.system({ "uv", "python", "find", "--directory", root_dir })
	if vim.v.shell_error ~= 0 then
		return fallback
	end

	local path = vim.trim(out)
	if path == "" or vim.fn.executable(path) ~= 1 then
		return fallback
	end

	return path
end

local definitions = {
	pyright = {
		-- Inject the interpreter per project root. `before_init` is the
		-- vim.lsp.config replacement for the old lspconfig `on_new_config`.
		before_init = function(_, config)
			config.settings = config.settings or {}
			config.settings.python = config.settings.python or {}
			config.settings.python.pythonPath = get_python_path(config.root_dir)
		end,
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

-- Mason has no clangd prebuilt for Linux aarch64 at all (e.g. Ubuntu on
-- UTM/QEMU), where it fails with "The current platform is unsupported". And on
-- Linux we prefer a single consistent source regardless of architecture, so on
-- every Linux host (arm64 and x86_64 alike) we install clangd from the system
-- package manager (apt.llvm.org via llvm.sh) and configure it directly, rather
-- than via Mason. macOS/Windows keep using Mason's prebuilt clangd.
local function clangd_from_system()
	return vim.fn.has("linux") == 1
end

-- LSP servers (plus extra tools) that Mason should install on this platform.
function M.ensure_installed()
	local ensure_installed = {}
	for name in pairs(definitions) do
		if not (name == "clangd" and clangd_from_system()) then
			table.insert(ensure_installed, name)
		end
	end
	vim.list_extend(ensure_installed, {
		"stylua",
	})

	return ensure_installed
end

-- Servers provided outside Mason (system package manager) on this platform.
-- These are configured against whatever binary is found on $PATH.
function M.system_servers()
	if clangd_from_system() then
		return { "clangd" }
	end
	return {}
end

return M
