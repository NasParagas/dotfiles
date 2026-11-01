#!/usr/bin/env bash
# shellcheck shell=bash

module_links() {
    link config "${HOME}/.config/mise"
}

MISE_VERSION="v2026.10.24"

module_install() {
    case "${OS}" in
        darwin) ;; # packages.brew
        ubuntu)
            if ! have mise; then
                ensure_local_bin
                curl -fsSL https://mise.run | MISE_VERSION="${MISE_VERSION}" sh
            fi
            ;;
        *) unsupported_os ;;
    esac

    mise install --yes
    export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/mise/shims:${PATH}"
}
