#!/usr/bin/env bash
# shellcheck shell=bash

setup_module_extras() {
    export PATH="${HOME}/.opencode/bin:${PATH}"

    if ! have opencode; then
        curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
    fi
}
