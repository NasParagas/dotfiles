#!/usr/bin/env bash
# shellcheck shell=bash

# tree-sitter CLI setup shared by host setup scripts.

install_tree_sitter_cli() {
    local target_version="${TREE_SITTER_CLI_VERSION:?TREE_SITTER_CLI_VERSION must be set}"
    local installed_version=""

    if command -v tree-sitter >/dev/null 2>&1; then
        installed_version="$(tree-sitter --version | awk '{print $2}')"
    fi

    if [[ "${installed_version}" != "${target_version}" ]]; then
        cargo install tree-sitter-cli --version "${target_version}" --locked
    fi
}
