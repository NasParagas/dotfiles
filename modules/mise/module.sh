#!/usr/bin/env bash
# shellcheck shell=bash

create_module_symlinks() {
    symlink config "${HOME}/.config/mise"
}

MISE_VERSION="v2026.10.24"
BASH_COMPLETION_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions"

# bash-completion は、このディレクトリの補完を初めて Tab を押したときに読み込む。
# シェルの起動ごとに uv を実行しないよう、ここで書き出しておく。
# uv を更新したら install.sh を再実行して書き直す
write_uv_completion() {
    mkdir -p "${BASH_COMPLETION_DIR}"
    uv generate-shell-completion bash >"${BASH_COMPLETION_DIR}/uv"
}

setup_module_extras() {
    case "${OS}" in
        darwin) ;; # packages.brew
        ubuntu)
            if ! have mise; then
                ensure_local_bin
                curl -fsSL https://mise.run | MISE_VERSION="${MISE_VERSION}" sh
            fi
            ;;
        *) die_unsupported_os ;;
    esac

    mise install --yes
    export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/mise/shims:${PATH}"
    write_uv_completion
}
