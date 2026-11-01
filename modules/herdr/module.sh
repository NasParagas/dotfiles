#!/usr/bin/env bash
# shellcheck shell=bash

install_module_extras() {
    ensure_local_bin

    if ! have herdr; then
        curl -fsSL https://herdr.dev/install.sh | env HERDR_INSTALL_DIR="${HOME}/.local/bin" sh
    fi
}
