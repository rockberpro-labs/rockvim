-- PHP / Laravel module: Intelephense, phpcs/phpstan, Blade
-- Must be set before the extra below is loaded (it reads this at load time)
vim.g.lazyvim_php_lsp = "intelephense"

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
