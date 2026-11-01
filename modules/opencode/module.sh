#!/usr/bin/env bash
# shellcheck shell=bash

module_install() {
    export PATH="${HOME}/.opencode/bin:${PATH}"

    if ! have opencode; then
        curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
    fi
}
