#!/usr/bin/env bash
# shellcheck shell=bash

module_install() {
    if [[ ! -x "${HOME}/.cargo/bin/rustc" ]]; then
        curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
    fi
}
