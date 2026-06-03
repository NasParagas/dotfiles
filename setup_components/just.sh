#!/usr/bin/env bash
# shellcheck shell=bash

# just setup shared by host setup scripts.

install_just_for_linux() {
    local version="${JUST_VERSION:?JUST_VERSION must be set}"
    local arch
    local tmp_dir

    arch="$(uname -m)"
    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"

    curl -fL \
        -o "${tmp_dir}/just.tar.gz" \
        "https://github.com/casey/just/releases/download/${version}/just-${version}-${arch}-unknown-linux-musl.tar.gz"

    tar xf "${tmp_dir}/just.tar.gz" -C "${tmp_dir}" just
    sudo install -m 0755 "${tmp_dir}/just" /usr/local/bin/just
}

install_just_for_macos() {
    local version="${JUST_VERSION:?JUST_VERSION must be set}"
    local arch
    local tmp_dir

    arch="$(uname -m | sed -e 's/arm64/aarch64/')"
    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"
    setup_ensure_local_bin

    curl -fL \
        -o "${tmp_dir}/just.tar.gz" \
        "https://github.com/casey/just/releases/download/${version}/just-${version}-${arch}-apple-darwin.tar.gz"

    tar xf "${tmp_dir}/just.tar.gz" -C "${tmp_dir}" just
    install -m 0755 "${tmp_dir}/just" "${HOME}/.local/bin/just"
}
