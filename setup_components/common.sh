#!/usr/bin/env bash
# shellcheck shell=bash

# Shared helpers for setup component scripts.
# This file defines functions only; callers control execution order.

SETUP_TMP_DIRS=()

setup_register_tmp_dir() {
    SETUP_TMP_DIRS+=("$1")
}

setup_cleanup_tmp_dirs() {
    if ((${#SETUP_TMP_DIRS[@]} > 0)); then
        rm -rf "${SETUP_TMP_DIRS[@]}"
    fi
}

setup_enable_tmp_cleanup() {
    trap setup_cleanup_tmp_dirs EXIT
}

setup_ensure_local_bin() {
    install -d -m 0755 "${HOME}/.local/bin"
    export PATH="${HOME}/.local/bin:${PATH}"
}
