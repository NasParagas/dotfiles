-- [[ Setting options ]]
-- See `:help vim.o
-- see `:help option-list`

-- Display absolute line numbers.
vim.o.number = true

-- Display relative line numbers from the cursor line.
vim.o.relativenumber = true

-- Automatically reload files when changed outside neovim
vim.opt.autoread = true

-- Create swap file
vim.opt.swapfile = false

-- Preserve indentation for wrapped lines
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Ignore case in search unless the pattern contains uppercase or setting \C
-- \C: case-sensitive search
-- \c: case-insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Configure how new split pane should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Show invisible whitespave chars
vim.o.list = true
-- Difine symbols
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live while typing
vim.o.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 8
-- Left and Right
vim.o.sidescrolloff = 8

-- Ask whether to save changes before :q, :e, etc.
vim.o.confirm = true

-- Convert tab to space.
-- NOTE: Other releted settings is configured in each filetype setting files.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- On SSH sessions there is no local clipboard tool, so copy through the
-- terminal with OSC 52. Auto-detection fails on WezTerm (it never answers
-- the OSC 52 read query), so set the provider explicitly. Paste falls back
-- to the unnamed register because WezTerm blocks clipboard reads; use the
-- terminal's paste (Ctrl+Shift+V) to bring in text from outside Neovim.
if vim.env.SSH_TTY then
	local osc52 = require("vim.ui.clipboard.osc52")
	local function paste_fallback()
		return vim.split(vim.fn.getreg('"'), "\n")
	end
	vim.g.clipboard = {
		name = "OSC 52",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = paste_fallback, ["*"] = paste_fallback },
	}
end
