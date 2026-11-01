#!/usr/bin/env bash
# shellcheck shell=bash

create_module_symlinks() {
    case "${OS}" in
        darwin) symlink config.yaml "${HOME}/Library/Preferences/clangd/config.yaml" ;;
        ubuntu) symlink config.yaml "${HOME}/.config/clangd/config.yaml" ;;
        *) die_unsupported_os ;;
    esac
}
