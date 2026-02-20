-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", { desc = "Move focus to the upper window" })

-- jkでinsert -> normal
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- 変数名・関数名などの一括変更
vim.keymap.set("n", "<leader>RE", vim.lsp.buf.rename, { silent = true, desc = "LSP Rename" })

-- ありえないぐらい間違えるので無効化
vim.keymap.set({ "n", "v", "s", "o", "i", "t" }, "<C-z>", "<nop>", { noremap = true, silent = true })
