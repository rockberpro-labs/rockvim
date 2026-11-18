-- Blade (Laravel) support
vim.filetype.add({
  pattern = { [".*%.blade%.php"] = "blade" },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "blade", "php_only", "html", "css", "scss", "jsdoc" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "blade-formatter" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { blade = { "blade-formatter" } },
    },
  },
}
