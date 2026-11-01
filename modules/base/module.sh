#!/usr/bin/env bash
# shellcheck shell=bash

# Preconditions that package installation depends on. install.sh installs the
# packages right after this file is sourced, so the checks run at source time.
if ((LINK_ONLY == 0)); then
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
    esac
fi

module_install() {
    ensure_local_bin
}
