#!/usr/bin/env bash
# shellcheck shell=bash

module_links() {
    link config "${HOME}/.config/wezterm"
}

module_install() {
    case "${OS}" in
        darwin) ;; # installed by hand
        ubuntu)
            curl -fsSL https://apt.fury.io/wez/gpg.key | as_root gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | as_root tee /etc/apt/sources.list.d/wezterm.list >/dev/null
            as_root chmod 644 /usr/share/keyrings/wezterm-fury.gpg
            as_root apt-get update -y
            as_root apt-get install -y --no-install-recommends wezterm-nightly
            ;;
        *) unsupported_os ;;
    esac
}
