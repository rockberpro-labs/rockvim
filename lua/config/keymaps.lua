-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>xc", "<cmd>cexpr [] | cclose<cr>", { desc = "Clear Quickfix List" })

-- Reorder bufferline buffers
vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })

-- Close all buffers
vim.keymap.set("n", "<leader>ba", function()
  Snacks.bufdelete.all()
end, { desc = "Delete All Buffers" })

-- Reorder tabpages
vim.keymap.set("n", "<leader><tab>L", function()
  pcall(vim.cmd, "+tabmove")
end, { desc = "Move tab right" })
vim.keymap.set("n", "<leader><tab>H", function()
  pcall(vim.cmd, "-tabmove")
end, { desc = "Move tab left" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Paste the unnamed register inside the innermost bracket pair around the
-- cursor (on the opening/closing bracket or anywhere inside). Pasted below the
-- cursor line (after the opening line if on "{", before the closing bracket if
-- on "}"), reindenting the pasted lines.
vim.keymap.set("n", "<leader>pib", function()
  local best
  local cur = vim.api.nvim_win_get_cursor(0)
  for _, p in ipairs({ { "{", "}" }, { "(", ")" }, { "[", "]" } }) do
    local o, c = "\\V" .. p[1], "\\V" .. p[2]
    local line = vim.api.nvim_get_current_line()
    local ch = line:sub(cur[2] + 1, cur[2] + 1)
    local open, close
    if ch == p[1] then
      vim.cmd("normal! %")
      close = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, cur)
      open = cur
    else
      if ch == p[2] then
        vim.cmd("normal! %")
        open = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, cur)
        close = cur
      else
        local op = vim.fn.searchpairpos(o, "", c, "bnW")
        local cl = vim.fn.searchpairpos(o, "", c, "nW")
        if op[1] > 0 and cl[1] > 0 then
          open, close = { op[1], op[2] - 1 }, { cl[1], cl[2] - 1 }
        end
      end
    end
    if open and close and (not best or open[1] > best.open[1] or (open[1] == best.open[1] and open[2] > best.open[2])) then
      best = { open = open, close = close }
    end
  end
  if not best then
    return vim.notify("No enclosing bracket", vim.log.levels.WARN)
  end

  local reg = vim.fn.getreg('"', 1, true)
  if #reg > 1 and reg[#reg] == "" then
    table.remove(reg)
  end
  local orow, ocol, crow, ccol = best.open[1], best.open[2], best.close[1], best.close[2]
  local at, extra = nil, 0
  local function line(n)
    return vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
  end
  if crow == orow then
    -- closing bracket on the opening line: move it (and what follows) to its own line
    vim.api.nvim_buf_set_text(0, crow - 1, ccol, crow - 1, ccol, { "", "" })
    at, extra = crow + 1, 1
  elseif cur[1] == crow then
    if line(crow):sub(1, ccol):match("%S") then
      vim.api.nvim_buf_set_text(0, crow - 1, ccol, crow - 1, ccol, { "", "" })
      crow = crow + 1
    end
    at, extra = crow, 1
  elseif cur[1] == orow then
    if line(orow):sub(ocol + 2):match("%S") then
      vim.api.nvim_buf_set_text(0, orow - 1, ocol + 1, orow - 1, ocol + 1, { "", "" })
      extra = 1
    end
    at = orow + 1
  else
    at = cur[1] + 1
  end
  vim.api.nvim_buf_set_lines(0, at - 1, at - 1, false, reg)
  vim.cmd(string.format("silent %d,%dnormal! ==", at, at + #reg - 1 + extra))
  vim.api.nvim_win_set_cursor(0, { at, 0 })
  vim.cmd("normal! ^")
end, { desc = "Paste inside bracket block (reflow)" })

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

require("which-key").add({
  { "<leader>cf", group = "format" },
  { "<leader>p", group = "paste", icon = "󰆒 " },
  { "<leader>pi", group = "paste inside" },
})
