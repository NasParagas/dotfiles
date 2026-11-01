# shellcheck shell=bash

# Shims rather than `mise activate`: no work at shell startup, and tools started
# outside an interactive shell, such as Neovim's LSP servers, resolve the same way.
path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"

case $- in
*i*)
    if command -v uv >/dev/null 2>&1; then
        eval "$(uv generate-shell-completion bash)"
    fi
    ;;
esac
