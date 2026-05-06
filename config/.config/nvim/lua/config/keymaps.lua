-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })

-- Delete word backward (Ctrl+Backspace) in insert mode
vim.keymap.set("i", "<C-H>", "<C-o>db", { noremap = true, silent = true })

-- Delete word forward (Ctrl+Delete) in insert mode
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { noremap = true, silent = true })

-- Jump word backward/forward in Insert mode
vim.keymap.set("i", "<C-l>", "<C-o>w", { noremap = true, silent = true }) -- jump forward one word
vim.keymap.set("i", "<C-h>", "<C-o>b", { noremap = true, silent = true }) -- jump back one word
