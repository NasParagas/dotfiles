#!/usr/bin/env bash
set -euo pipefail

# This script creates symbolic links for configuration files from the dotfiles repository to the home directory.

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
SOURCE_ROOT="$(cd "$DOTFILES_ROOT" && pwd -P)"

TARGETS=(
    ".bash_profile"
    ".bashrc"
    ".config/nvim"
    ".config/wezterm"
    ".config/git"
    ".codex"
    ".aerospace.toml"
)

timestamp="$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

# Create symbolic links for each target
for name in "${TARGETS[@]}"; do
    src="$SOURCE_ROOT/$name"
    dst="$HOME/$name"

    # check if source exists
    if [[ ! -e "$src" && ! -L "$src" ]]; then
        error "source not found: $src"
        exit 1
    fi

    # check if dest is already linked to the src
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        info "already linked: $dst -> $src"
        continue
    fi

    # backup existing file or link
    if [[ -e "$dst" || -L "$dst" ]]; then
        backup="${dst}.backup-${timestamp}"
        warn "backup: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    # create symlink
    info "link: $dst -> $src"
    ln -s "$src" "$dst"
done
