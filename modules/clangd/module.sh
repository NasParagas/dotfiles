#!/usr/bin/env bash
# shellcheck shell=bash

module_links() {
    case "${OS}" in
        darwin) link config.yaml "${HOME}/Library/Preferences/clangd/config.yaml" ;;
        ubuntu) link config.yaml "${HOME}/.config/clangd/config.yaml" ;;
        *) unsupported_os ;;
    esac
}
