#!/usr/bin/env bash
# shellcheck shell=bash

# OpenCode setup shared by platform setup scripts.

install_opencode() {
    export PATH="${HOME}/.opencode/bin:${PATH}"

    if ! command -v opencode >/dev/null 2>&1; then
        curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
    fi

    opencode --version
}
