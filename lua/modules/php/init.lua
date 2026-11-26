-- PHP / Laravel module: phpactor, phpcs/phpstan, Blade
-- Must be set before the extra below is loaded (it reads this at load time)
vim.g.lazyvim_php_lsp = "phpactor"

-- Blade (Laravel) support
vim.filetype.add({
  pattern = { [".*%.blade%.php"] = "blade" },
})

-- PHP indents with 4 spaces (PSR-12); LazyVim's global default is 2
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_php_indent", { clear = true }),
  pattern = "php",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Nearest phpstan config above `path` (file or directory), if any
local function phpstan_config(path)
  return vim.fs.find({ "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" }, {
    path = path,
    upward = true,
  })[1]
end

return {
  { import = "lazyvim.plugins.extras.lang.php" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          -- Run the Mason phar with short_open_tag on, so files opening with `<?` get parsed
          -- (the system php.ini has it off, and phpactor's tokenizer follows the runtime setting)
          -- Skip URI-scheme buffers (diffview://, fugitive://): phpactor rejects their root with "unknown scheme"
          root_dir = function(bufnr, on_dir)
            if vim.api.nvim_buf_get_name(bufnr):match("^%a[%w+.-]*://") then return end
            local root = vim.fs.root(bufnr, { ".git", "composer.json", ".phpactor.json", ".phpactor.yml" })
            if root then on_dir(root) end
          end,
          cmd = {
            "php",
            "-d",
            "short_open_tag=On",
            vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
            "language-server",
          },
        },
        -- Auto-enabled by mason-lspconfig; lspconfig's default starts it with no root outside
        -- Laravel projects and on URI-scheme buffers, where it fails with "unknown scheme"
        laravel_ls = {
          root_dir = function(bufnr, on_dir)
            if vim.api.nvim_buf_get_name(bufnr):match("^%a[%w+.-]*://") then return end
            local root = vim.fs.root(bufnr, { "artisan" })
            if root then on_dir(root) end
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "blade", "php_only", "html", "css", "scss" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "blade-formatter", "phpstan" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- repeat phpcs: lists are replaced, not merged
      linters_by_ft = { php = { "phpcs", "phpstan" } },
      linters = {
        phpstan = {
          -- Only run in projects that opted in with a phpstan config
          condition = function(ctx)
            return phpstan_config(ctx.dirname) ~= nil
          end,
          -- Project's own phpstan (matching version + extensions), else the one on PATH
          cmd = function()
            local config = phpstan_config(vim.api.nvim_buf_get_name(0))
            local local_bin = config and (vim.fs.dirname(config) .. "/vendor/bin/phpstan")
            return local_bin and vim.fn.executable(local_bin) == 1 and local_bin or "phpstan"
          end,
          args = {
            "analyze",
            "--error-format=json",
            "--no-progress",
            "--memory-limit=1G",
            function()
              return "--configuration=" .. phpstan_config(vim.api.nvim_buf_get_name(0))
            end,
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { blade = { "blade-formatter" } },
    },
  },
}
