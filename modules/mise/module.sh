#!/usr/bin/env bash
# shellcheck shell=bash

create_module_symlinks() {
    symlink config "${HOME}/.config/mise"
}

MISE_VERSION="v2026.10.24"

setup_module_extras() {
    case "${OS}" in
        darwin) ;; # packages.brew
        ubuntu)
            if ! have mise; then
                ensure_local_bin
                curl -fsSL https://mise.run | MISE_VERSION="${MISE_VERSION}" sh
            fi
            ;;
        *) die_unsupported_os ;;
    esac

    mise install --yes
    export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/mise/shims:${PATH}"
}
