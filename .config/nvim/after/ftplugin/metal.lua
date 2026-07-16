-- Indentation according to C/C++ syntax
vim.opt_local.cindent = true
vim.opt_local.commentstring = "// %s"

-- No LSP exists for Metal Shading Language, so run the real metal
-- compiler on load/save and surface its output as diagnostics.
if vim.b.metal_lint_attached then
	return
end
vim.b.metal_lint_attached = true

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
	vim.system(
		{ "xcrun", "-sdk", "macosx", "metal", "-fsyntax-only", "-Wall", path },
		{ text = true },
		function(res)
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
		end
	)
end

vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "Lint Metal shader with the metal compiler",
	buffer = 0,
	callback = function(args)
		lint(args.buf)
	end,
})

lint(vim.api.nvim_get_current_buf())
