-- Blade (Laravel) support
vim.filetype.add({
  pattern = { [".*%.blade%.php"] = "blade" },
})

-- Lowest PHP version a project supports, from composer.json (platform pin, else require.php)
local function composer_php_version(root)
  local path = root and (root .. "/composer.json")
  if not path or vim.fn.filereadable(path) == 0 then
    return nil
  end
  local ok, composer = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
  if not ok or type(composer) ~= "table" then
    return nil
  end
  local constraint = vim.tbl_get(composer, "config", "platform", "php") or vim.tbl_get(composer, "require", "php")
  local version = type(constraint) == "string" and constraint:match("%d+%.?%d*%.?%d*")
  if not version then
    return nil
  end
  local parts = vim.split(version, ".", { plain = true, trimempty = true })
  for i = #parts + 1, 3 do
    parts[i] = "0"
  end
  return table.concat(parts, ".")
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- gD: declaration isn't supported by intelephense/vtsls/vue_ls, fall back to definition
        ["*"] = {
          keys = {
            {
              "gD",
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                  if client:supports_method("textDocument/declaration", bufnr) then
                    return vim.lsp.buf.declaration()
                  end
                end
                vim.lsp.buf.definition()
              end,
              desc = "Goto Declaration (or Definition)",
            },
          },
        },
        intelephense = {
          settings = {
            -- Index files using `<?` short open tags (server's workspace default is false)
            intelephense = { environment = { shortOpenTag = true } },
          },
          before_init = function(_, config)
            local version = composer_php_version(config.root_dir)
            if version then
              config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                intelephense = { environment = { phpVersion = version } },
              })
            end
          end,
        },
      },
    },
  },
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
