#!/usr/bin/env bash
# shellcheck shell=bash

# パッケージ導入に必要な前提を確認し、後続の module も使う PATH を整える
ensure_module_prerequisites() {
    case "${OS}" in
    darwin)
        xcode-select -p >/dev/null 2>&1 || die "Xcode Command Line Tools are required. Run: xcode-select --install"
        if ! have brew && [[ -x /opt/homebrew/bin/brew ]]; then
            export PATH="/opt/homebrew/bin:${PATH}"
        fi
        have brew || die "Homebrew is required. Install it from https://brew.sh/ and rerun."
        ;;
    ubuntu)
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"
        if ((EUID != 0)); then
            have sudo || die "'sudo' command not found."
            sudo -v || die "sudo privileges are required."
        fi
        ;;
    *) die_unsupported_os ;;
    esac
}

install_module_extras() {
    ensure_local_bin
}
