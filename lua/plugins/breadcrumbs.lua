return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- the navic extra appends navic to the statusline; keep it only in the winbar
      for i = #opts.sections.lualine_c, 1, -1 do
        local c = opts.sections.lualine_c[i]
        if type(c) == "table" and c[1] == "navic" then
          table.remove(opts.sections.lualine_c, i)
        end
      end
      local crumbs = {
        { "filename", path = 1, symbols = { modified = "", readonly = "" } },
        { "navic", color_correction = "dynamic", padding = { left = 1, right = 0 } },
      }
      opts.winbar = { lualine_c = crumbs }
      opts.inactive_winbar = { lualine_c = { crumbs[1] } }
      opts.options.disabled_filetypes = opts.options.disabled_filetypes or {}
      opts.options.disabled_filetypes.winbar =
        { "snacks_dashboard", "snacks_picker_list", "snacks_layout_box", "trouble", "help", "lazy", "mason", "noice" }
    end,
  },
}
