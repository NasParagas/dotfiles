-- Metal has its own compiler diagnostics; clangd must not attach to it.
-- Keep the existing CUDA filetypes for clangd and map their parsers separately.
vim.filetype.add({
	extension = {
		metal = "metal",
		cu = "cu",
		cuh = "cuh",
	},
})
