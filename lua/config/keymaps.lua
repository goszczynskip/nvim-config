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

-- -- Add keymaps for CodeCompanion
-- vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionToggle<cr>", {
--   desc = "Chat with AI",
--   silent = true,
-- })
--
-- vim.keymap.set("n", "<leader>ai", "<cmd>CodeCompanionInlineAssist<cr>", {
--   desc = "Inline AI Assist",
--   silent = true,
-- })
--
-- vim.keymap.set(
--   "n",
--   "<leader>aa",
--   "<cmd>CodeCompanionActions<cr>",
--   { noremap = true, desc = "AI Actions", silent = true }
-- )
-- vim.keymap.set(
--   "v",
--   "<leader>aa",
--   "<cmd>CodeCompanionActions<cr>",
--   { noremap = true, desc = "AI Actions (visual mode)", silent = true }
-- )
-- vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle AI Chat", })
-- vim.keymap.set("v", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle AI Chat (visual mode)" })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add Selection to AI Buffer (visual mode)" })
-- vim.keymap.set("n", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add File to AI Buffer" })
--
-- -- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cab cc CodeCompanion]])
--
-- require("which-key").add({
--   { "<leader>a", group = "CodeCompanion" },
-- })
