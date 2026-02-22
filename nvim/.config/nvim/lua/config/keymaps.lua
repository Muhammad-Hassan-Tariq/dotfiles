-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })

-- Jump word backward/forward in Insert mode
vim.keymap.set("i", "<C-l>", "<C-o>w", { noremap = true, silent = true }) -- jump forward one word
vim.keymap.set("i", "<C-h>", "<C-o>b", { noremap = true, silent = true }) -- jump back one word
