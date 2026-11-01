#!/usr/bin/env bash
set -euo pipefail

# install.sh が作ったリンクを削除し、置き換えられていたファイルを元に戻す
# 導入したパッケージやツールはそのまま残す

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [--dry-run]

Remove the symlinks recorded by install.sh and restore the newest backup of
each path. Packages and tools installed by install.sh are not removed.

Options:
  --dry-run  Show what would change; change nothing
EOF
}

# ---- 引数の解析 ----
DRY_RUN=0

if (($# > 1)); then
    print_usage >&2
    exit 2
fi

case "${1:-}" in
    "") ;;
    --dry-run) DRY_RUN=1 ;;
    -h | --help)
        print_usage
        exit 0
        ;;
    *)
        print_usage >&2
        exit 2
        ;;
esac

# ---- 共通処理の読み込み ----
# shellcheck source=lib/common.sh
source "${REPO_ROOT}/lib/common.sh"
# shellcheck source=lib/symlink.sh
source "${REPO_ROOT}/lib/symlink.sh"

if [[ ! -f "${SYMLINK_MANIFEST}" ]]; then
    info "no links recorded in ${SYMLINK_MANIFEST}; nothing to do"
    exit 0
fi

# ---- 処理関数 ----
# 変更を伴う関数は、表示の後に DRY_RUN を確認して戻る

# リンク作成後に、このリポジトリへのリンク以外へ置き換えられたパスか
is_replaced_by_hand() {
    ! is_repo_symlink "$1" && [[ -e "$1" || -L "$1" ]]
}

remove_symlink() {
    is_repo_symlink "$1" || return 0

    info "remove link: $1"
    ((DRY_RUN == 0)) || return 0
    rm "$1"
}

# バックアップ名の末尾は日時で、glob は名前順に展開されるので、最後の候補が最新になる
find_latest_backup() {
    local candidate latest=""

    for candidate in "$1".backup-*; do
        if [[ -e "${candidate}" || -L "${candidate}" ]]; then
            latest="${candidate}"
        fi
    done

    printf '%s' "${latest}"
}

# リンクを消したことで空になったディレクトリを、$HOME の下に限って削除する
remove_empty_parents() {
    local dir

    ((DRY_RUN == 0)) || return 0

    dir="$(dirname "$1")"
    while [[ "${dir}" == "${HOME}/"* ]] && rmdir "${dir}" 2>/dev/null; do
        dir="$(dirname "${dir}")"
    done
}

# バックアップがなければ、空になった親ディレクトリを片付ける
restore_backup() {
    local backup
    backup="$(find_latest_backup "$1")"

    if [[ -z "${backup}" ]]; then
        remove_empty_parents "$1"
        return 0
    fi

    info "restore: ${backup} -> $1"
    ((DRY_RUN == 0)) || return 0
    mv "${backup}" "$1"
}

remove_manifest() {
    ((DRY_RUN == 0)) || return 0

    rm "${SYMLINK_MANIFEST}"
    remove_empty_parents "${SYMLINK_MANIFEST}"
    info "links removed. Open a new shell to pick up the changes."
}

# ---- manifest のパスを順に処理 ----
KEPT=0

while IFS= read -r path; do
    if is_replaced_by_hand "${path}"; then
        warn "left alone, not a link into this repository: ${path}"
        KEPT=1
        continue
    fi

    # ここに来るのは、このリポジトリへのリンクか、すでに何もないパス
    remove_symlink "${path}"
    restore_backup "${path}"
done < <(sort -u "${SYMLINK_MANIFEST}")

remove_manifest

if ((KEPT != 0)); then
    warn "some paths were left alone; check them by hand"
fi
