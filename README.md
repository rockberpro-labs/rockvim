# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Modules

Languages live in `lua/modules/<name>/` (extras + LSP config). Enable them per machine:
copy `lua/config/modules.example.lua` to `lua/config/modules.lua` (gitignored) and list names, e.g. `{ "php", "typescript" }`. Available: `php`, `typescript`.

Notes: `lazy-lock.json` only records plugins of enabled modules, so commit it from the full setup. Enabling a language extra via `:LazyExtras` writes to `lazyvim.json` globally, bypassing modules.
