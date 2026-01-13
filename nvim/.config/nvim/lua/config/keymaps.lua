-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Append semicolon at end of line and start a new line below
vim.keymap.set("i", ";;", "<Esc>A;<CR>", {
    desc = "Append semicolon and move to new line",
    noremap = true,
    silent = true,
})

-- Jump to next line while adding semicolon
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })

-- Scrool down and center the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center view" })
