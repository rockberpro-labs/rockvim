return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- gD: declaration isn't supported by every server (intelephense/vtsls/vue_ls), fall back to definition
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
      },
    },
  },
}
