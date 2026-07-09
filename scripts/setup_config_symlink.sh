#!/usr/bin/env bash
set -euo pipefail

# This script creates symbolic links for configuration files from the dotfiles repository to the home directory.

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
SOURCE_ROOT="$(cd "$DOTFILES_ROOT" && pwd -P)"

# Targets whose home-directory path is identical to their path in the repo.
TARGETS=(
    ".bash_profile"
    ".bashrc"
    ".config/nvim"
    ".config/wezterm"
    ".aerospace.toml"
)

timestamp="$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

# Symlink dst -> src, backing up whatever is already at dst.
link_path() {
    local src="$1"
    local dst="$2"

    # check if source exists
    if [[ ! -e "$src" && ! -L "$src" ]]; then
        error "source not found: $src"
        exit 1
    fi

    # check if dest is already linked to the src
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        info "already linked: $dst -> $src"
        return
    fi

    # backup existing file or link
    if [[ -e "$dst" || -L "$dst" ]]; then
        backup="${dst}.backup-${timestamp}"
        warn "backup: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    # create symlink
    mkdir -p "$(dirname "$dst")"
    info "link: $dst -> $src"
    ln -s "$src" "$dst"
}

# Create symbolic links for each same-path target
for name in "${TARGETS[@]}"; do
    link_path "$SOURCE_ROOT/$name" "$HOME/$name"
done

# clangd's user config lives at a different path per OS, so it can't go
# through the same-path TARGETS loop above.
case "$(uname -s)" in
Darwin)
    link_path "$SOURCE_ROOT/.config/clangd/config.yaml" "$HOME/Library/Preferences/clangd/config.yaml"
    ;;
Linux)
    link_path "$SOURCE_ROOT/.config/clangd/config.yaml" "${XDG_CONFIG_HOME:-$HOME/.config}/clangd/config.yaml"
    ;;
*)
    warn "unsupported OS for clangd user config: $(uname -s)"
    ;;
esac
