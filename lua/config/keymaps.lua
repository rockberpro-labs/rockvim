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

-- Format scopes: <leader>cf is a pure prefix (no action on timeout)
--   cff = whole file, cfi = inner block around cursor, cfs = visual selection
pcall(vim.keymap.del, { "n", "x" }, "<leader>cf")

vim.keymap.set("n", "<leader>cff", function()
  LazyVim.format({ force = true })
end, { desc = "Format file" })

vim.keymap.set("x", "<leader>cfs", function()
  LazyVim.format({ force = true })
end, { desc = "Format selection" })

vim.keymap.set("n", "<leader>cfi", function()
  local pairs_ = { { "{", "}" }, { "(", ")" }, { "[", "]" } }
  local best
  for _, p in ipairs(pairs_) do
    local o, c = vim.pesc(p[1]), vim.pesc(p[2])
    local open = vim.fn.searchpairpos(o, "", c, "bnW")
    local close = vim.fn.searchpairpos(o, "", c, "nW")
    if open[1] > 0 and close[1] > 0 then
      if not best or open[1] > best.open[1] or (open[1] == best.open[1] and open[2] > best.open[2]) then
        best = { open = open, close = close }
      end
    end
  end
  if not best then
    vim.notify("No enclosing block", vim.log.levels.WARN)
    return
  end
  local s, e = best.open[1] + 1, best.close[1] - 1
  if s > e then
    s, e = best.open[1], best.close[1]
  end
  require("conform").format({
    lsp_format = "fallback",
    range = { start = { s, 0 }, ["end"] = { e, #vim.fn.getline(e) } },
  })
end, { desc = "Format inner block" })

require("which-key").add({ { "<leader>cf", group = "format" } })
