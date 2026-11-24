-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "kj", "<esc>", { desc = "Exit insert mode" })
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>yp", ':let @ expand("%")', { desc = "Yank current buffer file path" })

vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("Copied file path")
end, { desc = "Copy file path" })
