local group = vim.api.nvim_create_augroup("dotfiles-core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight when yanking text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Make dir if not exist",
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	desc = "Equalize splits in every tab when the terminal is resized",
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})
