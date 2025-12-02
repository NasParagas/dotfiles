--困ったら :help と :checkhealth

-- See `:help mapleader`
-- leader を Space に設定
-- 最初に設定しとかないと拡張機能とかに影響があるらしい(キーバインド的に?)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- load "./lua/config/*.lua"
require("config.option")
require("config.keymap")
require("config.autocommand")
require("config.lazy")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
