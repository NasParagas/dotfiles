#!/usr/bin/env bash
# shellcheck shell=bash

# OS の判定と、OS に応じた処理
# 対応 OS を増やすときは、detect_os と lib/packages.sh の install_packages_for_module に
# 追加して ./install.sh を実行する。未対応の module は die_unsupported_os で止まる。

# OS (darwin, ubuntu) と PKG_MANAGER (brew, apt) を設定する
# shellcheck disable=SC2034 # PKG_MANAGER は lib/packages.sh が読む
detect_os() {
    case "$(uname -s)" in
        Darwin)
            OS="darwin"
            PKG_MANAGER="brew"
            ;;
        Linux)
            OS="$(. /etc/os-release && printf '%s' "${ID:-unknown}")"
            case "${OS}" in
                ubuntu) PKG_MANAGER="apt" ;;
                *) die "unsupported Linux distribution: ${OS}" ;;
            esac
            ;;
        *) die "unsupported OS: $(uname -s)" ;;
    esac
}

require_os() {
    [[ "${OS}" == "$1" ]] || die "profile '${PROFILE}' requires ${1}, but this host is ${OS}"
}

die_unsupported_os() {
    die "module '${MODULE}' does not support ${OS}"
}

# root で実行する。sudo がないコンテナでも動くよう、root のときは sudo を使わない
run_as_root() {
    if ((EUID == 0)); then
        "$@"
    else
        sudo "$@"
    fi
}
