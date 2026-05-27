# Neovim keymap plan

This document records the current `<leader>` mappings and the target namespace
layout. The runtime source of truth is still Neovim itself; use this file as a
design note when reorganizing mappings.

## How to inspect keymaps

Inside Neovim:

```vim
:Telescope keymaps
:verbose nmap <leader>
:verbose xmap <leader>
```

Common interactive checks:

- Press `<leader>` and wait for `which-key`.
- Use `<leader>sk` to open Telescope keymap search.
- Use `:verbose map <key>` when you need to know which file set a mapping.

## Current leader mappings

These are from a static search of `.config/nvim/lua` and `.config/nvim/after`.
Mappings under `unused_plugins/` and currently commented imports are excluded
from the main table.

| Key | Current action | Source |
|-----|----------------|--------|
| `<leader>q` | Open diagnostic quickfix list | `.config/nvim/lua/config/keymap.lua` |
| `<leader>f` | Format buffer | `.config/nvim/lua/plugins/conform.lua` |
| `<leader>gg` | LazyGit | `.config/nvim/lua/plugins/lazygit.lua` |
| `<leader>tt` | Toggle terminal (center float) | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>tn` | Open new terminal | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>ts` | Select running terminals | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>sh` | Search help | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sk` | Search keymaps | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sf` | Search files | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sF` | Search files, including hidden/no-ignore | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>ss` | Search Telescope builtins | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sw` | Search current word | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sg` | Live grep | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sG` | Live grep, including hidden/no-ignore | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sd` | Search diagnostics | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sr` | Resume Telescope picker | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>s.` | Search recent files | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>s/` | Live grep in open files | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>sn` | Search Neovim config files | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader><leader>` | Search buffers | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>/` | Search current buffer | `.config/nvim/lua/plugins/telescope.lua` |
| `<leader>rt` | Run `just test` | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>rw` | Run `just watch` | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>rc` | Run `just check` | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>rd` | Run `just dev` | `.config/nvim/lua/plugins/toggleterm.lua` |
| `<leader>ip` | Paste image from clipboard | `.config/nvim/lua/plugins/img_clip.lua` |
| `<leader>lh` | Toggle LSP inlay hints, buffer-local | `.config/nvim/lua/config/lsp/attach.lua` |

## Current which-key groups

| Prefix | Current group |
|--------|---------------|
| `<leader>s` | Search |
| `<leader>t` | Terminal |
| `<leader>r` | Run |
| `<leader>l` | LSP / Language |
| `<leader>i` | Image |
| `<leader>h` | Git Hunk |

## Conflicts and cleanup targets

- `<leader>h` is documented as a Git hunk group, but no active hunk mappings are
  currently defined under it.
- `<leader>l` exists in `plugins/nabla.lua`, but that plugin import is currently
  commented out in `config/lazy.lua`.

## Target namespace

| Prefix | Target meaning | Notes |
|--------|----------------|-------|
| `<leader>s` | Search | Keep Telescope here. |
| `<leader>t` | Terminal | Done. |
| `<leader>r` | Run | Project-local commands such as `just test`. |
| `<leader>g` | Git | Keep `<leader>gg` for LazyGit; add future Git commands here. |
| `<leader>b` | Browser | GUI browser handoff and web search helpers. |
| `<leader>m` | Mail | Himalaya or future mail commands. |
| `<leader>c` | Calendar / reminders | Read-only calendar/reminder views first. |
| `<leader>l` | LSP / language | Done. |
| `<leader>i` | Image | Done. |
| `<leader>q` | Quickfix / diagnostics | Current diagnostic quickfix can stay here. |
| `<leader>f` | Format | Current format mapping can stay here. |

## Pending additions

### Add

| Key | Target action |
|-----|---------------|
| `<leader>bu` | Open URL/file under cursor in GUI browser |
| `<leader>bs` | Search in GUI browser through shell helper |
| `<leader>mi` | Open mail inbox, after Himalaya setup |
| `<leader>cc` | Show today's calendar |
| `<leader>cu` | Show upcoming reminders |

## which-key target groups

```lua
{
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]erminal" },
	{ "<leader>r", group = "[R]un" },
	{ "<leader>g", group = "[G]it" },
	{ "<leader>b", group = "[B]rowser" },
	{ "<leader>m", group = "[M]ail" },
	{ "<leader>c", group = "[C]alendar" },
	{ "<leader>l", group = "[L]SP / Language" },
	{ "<leader>i", group = "[I]mage" },
	{ "<leader>q", group = "[Q]uickfix / Diagnostics" },
}
```

## Remaining migration steps

1. Add project run mappings under `<leader>r...` after deciding on `just`.
2. Add `<leader>b...` browser keymaps after shell helper is in place.
3. Add `<leader>m...` / `<leader>c...` keymaps after CLI tools are settled.
