return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      width = 76, -- match the logo width so the logo and menu share one centered column
      sections = {
        {
          section = "terminal",
          -- logo.txt stores the escape char as the literal "␛" symbol, so convert it back
          cmd = "sed 's/␛/\\x1b/g' " .. vim.fn.stdpath("config") .. "/logo.txt",
          ttl = 0, -- no caching, so edits to logo.txt show immediately
          height = 7,
          width = 76,
          padding = 1,
          indent = 0,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    -- don't auto-open the explorer when nvim starts on a directory (`nvim .`)
    explorer = { replace_netrw = false },
    picker = {
      sources = {
        explorer = { layout = { layout = { position = "right" } } },
        -- open grep results in a tab (reuses the tab if the file is already open)
        grep = {
          win = {
            input = { keys = { ["<CR>"] = { "tabdrop", mode = { "n", "i" } } } },
            list = { keys = { ["<CR>"] = { "tabdrop", mode = { "n" } } } },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>D", function() Snacks.dashboard() end, desc = "Dashboard" },
  },
}
