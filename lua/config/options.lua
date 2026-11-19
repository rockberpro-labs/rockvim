-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use intelephense (free tier) for PHP instead of phpactor
vim.g.lazyvim_php_lsp = "intelephense"

-- Don't format on save; only format via the explicit format command (<leader>cf)
vim.g.autoformat = false

-- Keep new lines and wrapped lines aligned with the start of the previous line
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.breakindent = true
