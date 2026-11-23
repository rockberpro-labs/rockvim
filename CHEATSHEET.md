# Cheatsheet

Essential keys to get minimally competent with LazyVim. Mostly LazyVim and Vim defaults; custom ones are marked (custom). `<leader>` is Space.

## Navigation & UI

| Key | Action |
| --- | --- |
| `<leader>D` | Back to dashboard (custom) |
| `<leader>e` | File explorer |
| `Ctrl+h` / `Ctrl+l` | Move between explorer and editor |
| `H` / `L` | Previous / next buffer |
| `<leader>bd` | Close current buffer |

## Search

| Key | Action |
| --- | --- |
| `<leader>ff` | Find file |
| `<leader>sg` | Grep across project |
| `<leader>sw` | Grep word under cursor |
| `<leader>ss` | Go to symbol / method |
| `Alt+w` | Switch between picker input and list |

## Git

| Key | Action |
| --- | --- |
| `<leader>gs` | Git status |
| `<leader>gg` | Lazygit |

## LSP

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `gD` | Declaration (falls back to definition) |
| `<leader>cf` | Format (custom: no format on save) |

## Quickfix

| Key | Action |
| --- | --- |
| `<leader>xq` | Toggle quickfix list |
| `<leader>xc` | Clear quickfix list (custom) |

## Editing

| Key | Action |
| --- | --- |
| `J` | Join lines |
| `ciw` | Change inside word |
| `y` / `p` | Yank / paste |
| `]p` | Paste with indent adjusted to current line |
| `=` | Reindent (e.g. `=']` after paste; uses `indentexpr`, works in PHP) |
| `u` / `Ctrl+r` | Undo / redo |
| `Ctrl+v` | Visual block |
| `%` | Jump to matching bracket |
| `:e!` | Discard buffer changes |

## Motion & search

| Key | Action |
| --- | --- |
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of line |
| `Ctrl+_` / `Ctrl+0` | Go to beginning of line |
| `Ctrl+$` | Go to end of line |
| `Ctrl+b` / `Ctrl+f` | Page up / down |
| `*` then `n` | Search word under cursor, next match |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward |
