return {
  -- Disable browser preview (needs node); keep in-buffer render-markdown.nvim
  { "iamcco/markdown-preview.nvim", enabled = false },

  -- Silence line-length (MD013) warnings from markdownlint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function()
      local linter = require("lint").linters["markdownlint-cli2"]
      linter.args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.jsonc", "-" }
    end,
  },
}
