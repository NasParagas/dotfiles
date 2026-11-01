-- set <leader> to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

require("config.options")
require("config.filetypes")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.lazy")
