#!/usr/bin/env bash
# shellcheck shell=bash

# Logging and temporary-directory helpers.
# New macOS hosts start with Bash 3.2, so everything under lib/, profiles/ and
# modules/*/module.sh must stay compatible with it.

info() { printf '\033[1;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
die() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2
    exit 1
}

have() { command -v "$1" >/dev/null 2>&1; }

SETUP_TMP_DIRS=""

# 作成したディレクトリを TMP_DIR に入れる。
# $(make_tmp_dir) で受け取ると、サブシェルで SETUP_TMP_DIRS への記録が失われる。
make_tmp_dir() {
    TMP_DIR="$(mktemp -d)"
    SETUP_TMP_DIRS="${SETUP_TMP_DIRS} ${TMP_DIR}"
}

cleanup_tmp_dirs() {
    local dir
    for dir in ${SETUP_TMP_DIRS}; do
        rm -rf "${dir}"
    done
}

ensure_local_bin() {
    install -d -m 0755 "${HOME}/.local/bin"
    case ":${PATH}:" in
        *":${HOME}/.local/bin:"*) ;;
        *) export PATH="${HOME}/.local/bin:${PATH}" ;;
    esac
}
