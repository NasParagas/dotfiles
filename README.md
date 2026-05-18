# dotfiles

(改修中)

## Purpose

The purpose of this dotfile is to reproduce the environment within the scope of what can be completed by a script.

## Target Environment

| Component | Role                 | Status    | Config / Docs      |
|-----------|----------------------|-----------|--------------------|
| Neovim    | Editor               | Supported | `doc/neovim.md`    |
| WezTerm(config)   | Terminal emulator    | Planned   | `doc/wezterm.md`   |
| AeroSpace(config) | macOS window manager | Planned   | `doc/aerospace.md` |
| Codex CLI | Coding agent CLI     | Planned   | `doc/codex_cli.md` |


## Setup

TODO
On mac, see `doc/setup_mac.md`, on Ubuntu, see `doc/setup_ubuntu.md`.

## Major Dependencies

These tools may be installed during bootstrap, depending on the platform.

| Dependency      | Purpose                                  | Installed by      | Notes                                            |
|-----------------|------------------------------------------|-------------------|--------------------------------------------------|
| Git             | clone/update dotfiles                    | apt               | required                                         |
| curl / wget     | download installers and releases         | apt               | required                                         |
| Rust / Cargo    | install Rust-based tools                 | rustup            | used for `tree-sitter-cli` and development       |
| Node.js / npm   | JS tooling and Neovim ecosystem tools    | nvm / n           | required. currently installs Node 24             |
| tree-sitter-cli | parser tooling for Neovim                | cargo             |                                                  |
| lazygit         | Git TUI used from shell/Neovim           | Source build      | installed to `/usr/local/bin`                    |
| ripgrep         | fast search used by shell/Neovim plugins | apt               |                                                  |
| Deno            | JS/TS runtime                            | not automated yet | mark as planned/manual unless script installs it |

