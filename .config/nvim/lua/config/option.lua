-- [[ Setting options ]]
-- See `:help vim.o
-- see `:help option-list`

-- Display absolute line numbers.
vim.o.number = true

-- Display relative line numbers from the corsor line.
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
-- \c: case-insansitive search
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

-- Convert tab to space
vim.opt.expandtab = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
