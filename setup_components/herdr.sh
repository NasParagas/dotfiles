#!/usr/bin/env bash
# shellcheck shell=bash

# herdr setup shared by platform setup scripts.

install_herdr() {
    setup_ensure_local_bin

    if ! command -v herdr >/dev/null 2>&1; then
        curl -fsSL https://herdr.dev/install.sh | env HERDR_INSTALL_DIR="${HOME}/.local/bin" sh
    fi

    herdr --version
}
