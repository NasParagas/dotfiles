#!/usr/bin/env bash
# shellcheck shell=bash

# Neovim source build shared by host setup scripts.

install_neovim_from_source() {
    local version="${NEOVIM_VERSION:?NEOVIM_VERSION must be set}"
    local tag="v${version#v}"
    local neovim_dir="${HOME}/neovim"

    if [[ -d "${neovim_dir}/.git" ]]; then
        git -C "${neovim_dir}" fetch --depth 1 origin "refs/tags/${tag}:refs/tags/${tag}"
        git -C "${neovim_dir}" checkout --detach "${tag}"
    elif [[ -e "${neovim_dir}" ]]; then
        echo "Error: ${neovim_dir} exists but is not a git repository." >&2
        return 1
    else
        git clone https://github.com/neovim/neovim --branch "${tag}" --depth 1 "${neovim_dir}"
    fi

    make -C "${neovim_dir}" CMAKE_BUILD_TYPE=Release

    sudo make install
}
