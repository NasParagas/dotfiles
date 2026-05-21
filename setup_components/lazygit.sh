#!/usr/bin/env bash
# shellcheck shell=bash

# lazygit setup shared by host setup scripts.

install_lazygit_for_linux() {
    local version="${LAZYGIT_VERSION:?LAZYGIT_VERSION must be set}"
    local arch
    local tmp_dir

    arch="$(uname -m | sed -e 's/aarch64/arm64/')"
    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"

    curl -fL \
        -o "${tmp_dir}/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_linux_${arch}.tar.gz"

    tar xf "${tmp_dir}/lazygit.tar.gz" -C "${tmp_dir}" lazygit
    sudo install -m 0755 "${tmp_dir}/lazygit" /usr/local/bin/lazygit
}

install_lazygit_for_macos() {
    local version="${LAZYGIT_VERSION:?LAZYGIT_VERSION must be set}"
    local arch
    local tmp_dir

    arch="$(uname -m)"
    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"
    setup_ensure_local_bin

    curl -fL \
        -o "${tmp_dir}/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Darwin_${arch}.tar.gz"

    tar xf "${tmp_dir}/lazygit.tar.gz" -C "${tmp_dir}" lazygit
    install -m 0755 "${tmp_dir}/lazygit" "${HOME}/.local/bin/lazygit"
}
