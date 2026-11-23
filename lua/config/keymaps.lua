-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>xc", "<cmd>cexpr [] | cclose<cr>", { desc = "Clear Quickfix List" })

-- Paste the unnamed register inside the bracket under the cursor, pushing the
-- closing bracket down and reindenting the pasted lines.
vim.keymap.set("n", "<leader>pi", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if line:sub(col + 2):match("%S") then
    -- closing bracket on the same line: split it onto its own line, paste above it
    vim.cmd([[exe "normal! a\<CR>"]])
    vim.cmd("normal! [p")
  else
    vim.cmd("normal! ]p")
  end
  vim.cmd("normal! ']=']")
end, { desc = "Paste inside brackets (reflow)" })
