#!/usr/bin/env bash
# shellcheck shell=bash

# OS detection and package installation.
# Adding an OS means adding it to detect_os and install_packages, then running
# ./install.sh: modules without support for it stop with unsupported_os.

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

unsupported_os() {
    die "module '${MODULE}' does not support ${OS}"
}

# Run a command as root, for hosts and containers with or without sudo.
as_root() {
    if ((EUID == 0)); then
        "$@"
    else
        sudo "$@"
    fi
}

APT_UPDATED=0

# Print the package names in a list file, without comments and blank lines.
read_packages() {
    sed -e 's/#.*//' -e 's/[[:space:]]//g' -e '/^$/d' "$1"
}

install_casks() {
    local cask missing=""

    for cask in $(read_packages "$1"); do
        # Tapped casks are listed as owner/tap/name but installed as name.
        brew list --cask "${cask##*/}" >/dev/null 2>&1 || missing="${missing} ${cask}"
    done

    [[ -n "${missing}" ]] || return 0

    # shellcheck disable=SC2086 # cask names are deliberately word-split
    brew install --cask ${missing}
}

install_packages() {
    local file="$1" missing=""
    local package

    for package in $(read_packages "${file}"); do
        case "${PKG_MANAGER}" in
            brew) brew list --formula --versions "${package}" >/dev/null 2>&1 || missing="${missing} ${package}" ;;
            apt) missing="${missing} ${package}" ;;
        esac
    done

    [[ -n "${missing}" ]] || return 0

    # shellcheck disable=SC2086 # package names are deliberately word-split
    case "${PKG_MANAGER}" in
        brew) brew install ${missing} ;;
        apt)
            if ((APT_UPDATED == 0)); then
                as_root apt-get update -y
                APT_UPDATED=1
            fi
            as_root apt-get install -y --no-install-recommends ${missing}
            ;;
    esac
}
