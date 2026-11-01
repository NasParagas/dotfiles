#!/usr/bin/env bash
# shellcheck shell=bash

# module の packages.* を、OS のパッケージマネージャーで導入する
#
# install.sh は install_packages_for_module だけを呼ぶ。
# パッケージマネージャーごとの違いは、この関数より下に閉じ込める。

APT_UPDATED=0

# module のディレクトリにある、PKG_MANAGER 用の packages.* を導入する
install_packages_for_module() {
    local module_dir="$1"

    case "${PKG_MANAGER}" in
        brew)
            install_brew_formulae "${module_dir}/packages.brew"
            install_brew_casks "${module_dir}/packages.cask"
            ;;
        apt) install_apt_packages "${module_dir}/packages.apt" ;;
        *) die_unsupported_os ;;
    esac
}

# パッケージ一覧のファイルから、コメントと空行を除いた名前を出力する
read_packages() {
    sed -e 's/#.*//' -e 's/[[:space:]]//g' -e '/^$/d' "$1"
}

install_brew_formulae() {
    local file="$1"
    local formula missing=""

    [[ -f "${file}" ]] || return 0

    for formula in $(read_packages "${file}"); do
        brew list --formula --versions "${formula}" >/dev/null 2>&1 || missing="${missing} ${formula}"
    done

    [[ -n "${missing}" ]] || return 0

    # shellcheck disable=SC2086 # 名前の一覧を意図的に単語分割する
    brew install ${missing}
}

install_brew_casks() {
    local file="$1"
    local cask missing=""

    [[ -f "${file}" ]] || return 0

    for cask in $(read_packages "${file}"); do
        # tap の cask は owner/tap/name と書くが、確認は name で行う
        brew list --cask "${cask##*/}" >/dev/null 2>&1 || missing="${missing} ${cask}"
    done

    [[ -n "${missing}" ]] || return 0

    # shellcheck disable=SC2086 # 名前の一覧を意図的に単語分割する
    brew install --cask ${missing}
}

# 導入済みの判定は apt-get に任せる。apt-get update は1回の実行で1度だけ行う
install_apt_packages() {
    local file="$1"
    local packages

    [[ -f "${file}" ]] || return 0

    packages="$(read_packages "${file}")"
    [[ -n "${packages}" ]] || return 0

    if ((APT_UPDATED == 0)); then
        run_as_root apt-get update -y
        APT_UPDATED=1
    fi

    # shellcheck disable=SC2086 # 名前の一覧を意図的に単語分割する
    run_as_root apt-get install -y --no-install-recommends ${packages}
}
