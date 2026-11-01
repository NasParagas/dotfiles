#!/usr/bin/env bash
# shellcheck shell=bash

# シンボリックリンクの管理
#
# manifest には、install.sh が作ったリンクのパスを記録する。
# - 実行中: symlink が前回分の後ろへ1件ずつ追記する。途中で止まっても unlink.sh で元に戻せる
# - 実行後: prune_stale_symlinks が、manifest にあるのに今回作らなかったリンクを削除し、
#   compact_symlink_manifest が今回作ったリンクだけに書き直す
#
# unlink.sh は SYMLINK_MANIFEST と is_repo_symlink だけを使う。

SYMLINK_MANIFEST="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/links"
SYMLINKED_PATHS=""
BACKUP_SUFFIX="backup-$(date +%Y%m%d-%H%M%S)"

is_repo_symlink() {
    [[ -L "$1" && "$(readlink "$1")" == "${REPO_ROOT}/"* ]]
}

# symlink <module 内のパス> <リンク先>
symlink() {
    local src="${MODULE_DIR}/$1"
    local dst="$2"

    [[ -e "${src}" ]] || die "module '${MODULE}': link source not found: ${src}"

    SYMLINKED_PATHS="${SYMLINKED_PATHS}${dst}
"
    mkdir -p "$(dirname "${SYMLINK_MANIFEST}")"
    printf '%s\n' "${dst}" >>"${SYMLINK_MANIFEST}"

    if [[ -L "${dst}" && "$(readlink "${dst}")" == "${src}" ]]; then
        return 0
    fi

    if is_repo_symlink "${dst}"; then
        rm "${dst}"
    elif [[ -e "${dst}" || -L "${dst}" ]]; then
        warn "backup: ${dst} -> ${dst}.${BACKUP_SUFFIX}"
        mv "${dst}" "${dst}.${BACKUP_SUFFIX}"
    fi

    mkdir -p "$(dirname "${dst}")"
    info "link: ${dst} -> ${src}"
    ln -s "${src}" "${dst}"
}

# module 内のディレクトリの中身を、すべて指定のディレクトリへリンクする
# symlink_module_dir_contents <module 内のディレクトリ> <リンク先のディレクトリ>
symlink_module_dir_contents() {
    local dir="$1"
    local dst_dir="$2"
    local file name

    [[ -d "${MODULE_DIR}/${dir}" ]] || return 0

    for file in "${MODULE_DIR}/${dir}"/*; do
        [[ -e "${file}" ]] || continue
        name="$(basename "${file}")"
        symlink "${dir}/${name}" "${dst_dir}/${name}"
    done
}

is_symlinked_this_run() {
    grep -Fxq -- "$1" <<<"${SYMLINKED_PATHS}"
}

# 前回は作ったが今回は作らなかったリンクを削除する
prune_stale_symlinks() {
    local path

    [[ -f "${SYMLINK_MANIFEST}" ]] || return 0

    while IFS= read -r path; do
        [[ -n "${path}" ]] || continue

        if is_symlinked_this_run "${path}"; then
            continue
        fi

        if is_repo_symlink "${path}"; then
            info "remove stale link: ${path}"
            rm "${path}"
        fi
    done <"${SYMLINK_MANIFEST}"
}

compact_symlink_manifest() {
    mkdir -p "$(dirname "${SYMLINK_MANIFEST}")"
    printf '%s' "${SYMLINKED_PATHS}" >"${SYMLINK_MANIFEST}"
}
