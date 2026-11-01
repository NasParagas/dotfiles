#!/usr/bin/env bash
# shellcheck shell=bash

# Symlink management. Links are recorded in a manifest as they are made, so
# unlink.sh can undo a run that stopped halfway, and a later run can remove
# links left by modules that were dropped from the profile.

LINK_MANIFEST="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/links"
PREVIOUS_LINKS="$(cat "${LINK_MANIFEST}" 2>/dev/null || true)"
LINKED_PATHS=""
BACKUP_SUFFIX="backup-$(date +%Y%m%d-%H%M%S)"

is_repo_link() {
    [[ -L "$1" && "$(readlink "$1")" == "${REPO_ROOT}/"* ]]
}

# link <path relative to the module> <destination>
link() {
    local src="${MODULE_DIR}/$1"
    local dst="$2"

    [[ -e "${src}" ]] || die "module '${MODULE}': link source not found: ${src}"

    LINKED_PATHS="${LINKED_PATHS}${dst}
"
    mkdir -p "$(dirname "${LINK_MANIFEST}")"
    printf '%s\n' "${dst}" >>"${LINK_MANIFEST}"

    if [[ -L "${dst}" && "$(readlink "${dst}")" == "${src}" ]]; then
        return 0
    fi

    if is_repo_link "${dst}"; then
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
# link_contents <module 内のディレクトリ> <リンク先のディレクトリ>
link_contents() {
    local dir="$1"
    local dst_dir="$2"
    local file name

    [[ -d "${MODULE_DIR}/${dir}" ]] || return 0

    for file in "${MODULE_DIR}/${dir}"/*; do
        [[ -e "${file}" ]] || continue
        name="$(basename "${file}")"
        link "${dir}/${name}" "${dst_dir}/${name}"
    done
}

# Remove links from the previous run that this run no longer wants.
prune_stale_links() {
    local path

    while IFS= read -r path; do
        [[ -n "${path}" ]] || continue

        case "
${LINKED_PATHS}" in
            *"
${path}
"*) continue ;;
        esac

        if is_repo_link "${path}"; then
            info "remove stale link: ${path}"
            rm "${path}"
        fi
    done <<<"${PREVIOUS_LINKS}"

    mkdir -p "$(dirname "${LINK_MANIFEST}")"
    printf '%s' "${LINKED_PATHS}" >"${LINK_MANIFEST}"
}
