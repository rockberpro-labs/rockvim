-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>xc", "<cmd>cexpr [] | cclose<cr>", { desc = "Clear Quickfix List" })

-- Paste the unnamed register inside the innermost bracket pair around the
-- cursor (on the opening/closing bracket or anywhere inside), moving the
-- closing bracket onto its own line below the pasted text and reindenting.
vim.keymap.set("n", "<leader>pi", function()
  local best
  for _, p in ipairs({ { "{", "}" }, { "(", ")" }, { "[", "]" } }) do
    local o, c = "\\V" .. p[1], "\\V" .. p[2]
    local cur = vim.api.nvim_win_get_cursor(0)
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
  local orow, crow, ccol = best.open[1], best.close[1], best.close[2]
  if crow == orow then
    -- closing bracket on the opening line: move it (and what follows) to its own line
    vim.api.nvim_buf_set_text(0, crow - 1, ccol, crow - 1, ccol, { "", "" })
    crow = crow + 1
  elseif vim.api.nvim_buf_get_lines(0, crow - 1, crow, false)[1]:sub(1, ccol):match("%S") then
    vim.api.nvim_buf_set_text(0, crow - 1, ccol, crow - 1, ccol, { "", "" })
    crow = crow + 1
  end
  vim.api.nvim_buf_set_lines(0, crow - 1, crow - 1, false, reg)
  local last = crow - 1 + #reg + 1
  vim.cmd(string.format("silent %d,%dnormal! ==", orow + 1, last))
  vim.api.nvim_win_set_cursor(0, { crow, 0 })
  vim.cmd("normal! ^")
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
