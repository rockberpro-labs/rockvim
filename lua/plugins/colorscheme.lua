return {
  { "tanvirtin/monokai.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("monokai").setup({ palette = require("monokai").soda })
      end,
    },
  },
  -- drop the default themes so they aren't installed/loaded
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
}
