-- set <leader> to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- dedicated filetype so clangd (which cannot parse Metal) does not attach;
-- highlighting reuses the cpp treesitter parser, diagnostics come from
-- the real metal compiler (see after/ftplugin/metal.lua)
vim.filetype.add({
	extension = {
		metal = "metal",
		cu = "cu",
		cuh = "cuh",
	},
})

-- load "./lua/config/*.lua"
require("config.option")
require("config.keymap")
require("config.autocommand")
require("config.command")
require("config.lazy")
