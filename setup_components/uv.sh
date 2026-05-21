#!/usr/bin/env bash
# shellcheck shell=bash

# uv setup shared by host setup scripts.

install_uv() {
    setup_ensure_local_bin

    if ! command -v uv >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
    fi

    uv --version
}
