local M = {}

-- Use the Metal compiler's output as Neovim diagnostics.
local ns = vim.api.nvim_create_namespace("metal_lint")

local severities = {
	["fatal error"] = vim.diagnostic.severity.ERROR,
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
	note = vim.diagnostic.severity.INFO,
}

local function lint(buf)
	local path = vim.api.nvim_buf_get_name(buf)
	if path == "" then
		return
	end
	vim.system({ "xcrun", "-sdk", "macosx", "metal", "-fsyntax-only", "-Wall", path }, { text = true }, function(res)
		local diags = {}
		for line in (res.stderr or ""):gmatch("[^\n]+") do
			local file, lnum, col, sev, msg = line:match("^(.-):(%d+):(%d+): ([%a ]+): (.*)$")
			if file and severities[sev] then
				local d = {
					severity = severities[sev],
					message = msg,
					source = "metal",
				}
				if vim.fn.fnamemodify(file, ":p") == path then
					d.lnum = tonumber(lnum) - 1
					d.col = tonumber(col) - 1
				else
					-- error in an included file; anchor it to the top
					d.lnum = 0
					d.col = 0
					d.message = ("%s:%s: %s"):format(file, lnum, msg)
				end
				table.insert(diags, d)
			end
		end
		if res.code ~= 0 and #diags == 0 then
			vim.schedule(function()
				vim.notify("metal lint failed:\n" .. (res.stderr or ""), vim.log.levels.WARN)
			end)
			return
		end
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.diagnostic.set(ns, buf, diags)
			end
		end)
	end)
end

function M.attach(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if vim.b[bufnr].metal_lint_attached or vim.fn.executable("xcrun") ~= 1 then
		return
	end
	vim.b[bufnr].metal_lint_attached = true

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("dotfiles-metal-lint", { clear = false }),
		desc = "Lint Metal shader with the metal compiler",
		buffer = bufnr,
		callback = function(args)
			lint(args.buf)
		end,
	})
	lint(bufnr)
end

return M
