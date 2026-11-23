-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Don't format on save; only format via the explicit format command (<leader>cf)
vim.g.autoformat = false

-- Keep new lines and wrapped lines aligned with the start of the previous line
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.breakindent = true

-- Filetype/treesitter indentexpr overrides autoindent; clear it so new lines copy the previous indent
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  callback = function()
    -- PHP keeps its indentexpr so = can reindent
    if vim.bo.filetype == "php" then
      return
    end
    vim.opt_local.indentexpr = ""
    vim.opt_local.cindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.autoindent = true
  end,
})
