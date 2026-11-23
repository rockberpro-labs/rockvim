return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = { layout = { layout = { position = "right" } } },
      },
    },
  },
  keys = {
    { "<leader>D", function() Snacks.dashboard() end, desc = "Dashboard" },
  },
}
