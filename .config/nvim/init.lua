-- set <leader> to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.filetype.add({
	extension = {
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
