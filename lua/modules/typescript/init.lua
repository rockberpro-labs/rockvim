-- TypeScript / web module: vtsls, Vue, Tailwind, ESLint, Prettier
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.vue" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- Skip URI-scheme buffers (diffview://, fugitive://): lspconfig's root search can't walk them,
          -- falls back to root "." and the server rejects "file://." with "unknown scheme"
          root_dir = function(bufnr, on_dir)
            if vim.api.nvim_buf_get_name(bufnr):match("^%a[%w+.-]*://") then return end
            local default = dofile(vim.api.nvim_get_runtime_file("lsp/tailwindcss.lua", false)[1])
            default.root_dir(bufnr, on_dir)
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "html", "css", "scss", "jsdoc" },
    },
  },
}
