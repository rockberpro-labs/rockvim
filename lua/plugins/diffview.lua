local function base_branch()
  for _, b in ipairs({ "main", "master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", b })
    if vim.v.shell_error == 0 then return b end
  end
end

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  opts = {
    file_panel = {
      listing_style = "list",
      win_config = { width = 30 },
    },
    hooks = {
      -- start with the file panel hidden so the two diff panes get the full width
      view_opened = function()
        require("diffview.actions").toggle_files()
      end,
    },
  },
  keys = {
    {
      "<leader>gd",
      function()
        local b = base_branch()
        if not b then
          return vim.notify("No main or master branch found", vim.log.levels.WARN)
        end
        vim.cmd("DiffviewOpen " .. b .. "...HEAD")
      end,
      desc = "Diff against main/master",
    },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
  },
}
