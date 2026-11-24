-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Reload buffers changed on disk (e.g. by an AI agent in another pane)
vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("user_checktime", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- No spell checking in markdown (keeps wrap from LazyVim's wrap_spell)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_markdown_nospell", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})
