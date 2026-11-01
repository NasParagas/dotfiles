#!/usr/bin/env bash
# shellcheck shell=bash

module_install() {
    ensure_local_bin

    if ! have herdr; then
        curl -fsSL https://herdr.dev/install.sh | env HERDR_INSTALL_DIR="${HOME}/.local/bin" sh
    fi
}
