#!/usr/bin/env bash
# shellcheck shell=bash

module_install() {
    if [[ ! -x "${HOME}/.elan/bin/elan" ]]; then
        curl -fsSL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --no-modify-path
    fi
}
