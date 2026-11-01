#!/usr/bin/env bash
# shellcheck shell=bash

create_module_symlinks() {
    symlink config "${HOME}/.config/wezterm"
}

setup_module_extras() {
    case "${OS}" in
        darwin) ;; # installed by hand
        ubuntu)
            curl -fsSL https://apt.fury.io/wez/gpg.key | run_as_root gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | run_as_root tee /etc/apt/sources.list.d/wezterm.list >/dev/null
            run_as_root chmod 644 /usr/share/keyrings/wezterm-fury.gpg
            run_as_root apt-get update -y
            run_as_root apt-get install -y --no-install-recommends wezterm-nightly
            ;;
        *) die_unsupported_os ;;
    esac
}
