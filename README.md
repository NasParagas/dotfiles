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

Run the platform-specific setup script first, then link dotfiles.

```sh
# macOS host
bash environment_setup_for_host_macos.sh

# Ubuntu host
bash environment_setup_for_host_ubuntu.sh

# Ubuntu Docker image/container
bash environment_setup_for_docker_ubuntu.sh

# Link config files into $HOME
bash setup_config_symlink.sh
```

Shared tool versions live in `versions.sh`. Reusable install steps such as
Neovim, Node.js, lazygit, uv, HackGen, and Docker live under `setup_components/`.

## Major Dependencies

These tools may be installed during bootstrap, depending on the platform.

| Dependency      | Purpose                                  | Installed by      | Notes                                            |
|-----------------|------------------------------------------|-------------------|--------------------------------------------------|
| Git             | clone/update dotfiles                    | apt / brew        | required                                         |
| curl / wget     | download installers and releases         | apt / brew        | required                                         |
| Rust / Cargo    | install Rust-based tools                 | rustup            | used for `tree-sitter-cli` and development       |
| Node.js / npm   | JS tooling and Neovim ecosystem tools    | nvm               | version is managed in `versions.sh`              |
| tree-sitter-cli | parser tooling for Neovim                | cargo             | version is managed in `versions.sh`              |
| lazygit         | Git TUI used from shell/Neovim           | Source build      | version is managed in `versions.sh`              |
| Docker Engine   | container runtime on Ubuntu hosts        | Docker apt repo   | host Ubuntu only                                 |
| ripgrep         | fast search used by shell/Neovim plugins | apt / brew        |                                                  |
| Deno            | JS/TS runtime                            | not automated yet | mark as planned/manual unless script installs it |
