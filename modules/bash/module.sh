#!/usr/bin/env bash
# shellcheck shell=bash

HOMEBREW_BASH="/opt/homebrew/bin/bash"

create_module_symlinks() {
    symlink bashrc "${HOME}/.bashrc"
    symlink bash_profile "${HOME}/.bash_profile"
}

# macOS 標準の bash 3.2 では bash-completion@2 が動かないので、Homebrew の bash を使う
use_homebrew_bash_as_login_shell() {
    local login_shell

    [[ -x "${HOMEBREW_BASH}" ]] || die "Homebrew bash not found: ${HOMEBREW_BASH}"

    if ! grep -Fxq "${HOMEBREW_BASH}" /etc/shells; then
        printf '%s\n' "${HOMEBREW_BASH}" | run_as_root tee -a /etc/shells >/dev/null
    fi

    # $SHELL は起動時の値のままなので、ユーザー情報から現在の設定を読む
    login_shell="$(dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}')"
    [[ "${login_shell}" != "${HOMEBREW_BASH}" ]] || return 0

    run_as_root chsh -s "${HOMEBREW_BASH}" "$(id -un)"
    info "login shell changed to ${HOMEBREW_BASH}. Restart the terminal to use it."
}

setup_module_extras() {
    case "${OS}" in
        darwin) use_homebrew_bash_as_login_shell ;;
        ubuntu) ;;
        *) die_unsupported_os ;;
    esac
}
