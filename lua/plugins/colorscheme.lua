return {
  { "tanvirtin/monokai.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("monokai").setup({
          palette = require("monokai").soda,
          custom_hlgroups = {
            Visual = { bg = "#49483E" },
            VisualNOS = { bg = "#49483E" },
          },
        })
      end,
    },
  },
  -- drop the default themes so they aren't installed/loaded
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
}
