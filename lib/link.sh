#!/usr/bin/env bash
# shellcheck shell=bash

# Symlink management. Every link made by a run is recorded in a manifest, so a
# later run can remove links left by modules that were dropped from the profile.

LINK_MANIFEST="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/links"
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

    if [[ -L "${dst}" && "$(readlink "${dst}")" == "${src}" ]]; then
        return 0
    fi

    if is_repo_link "${dst}"; then
        rm "${dst}"
    elif [[ -f "${dst}" && ! -L "${dst}" ]] && cmp -s "${src}" "${dst}"; then
        rm "${dst}"
    elif [[ -e "${dst}" || -L "${dst}" ]]; then
        warn "backup: ${dst} -> ${dst}.${BACKUP_SUFFIX}"
        mv "${dst}" "${dst}.${BACKUP_SUFFIX}"
    fi

    mkdir -p "$(dirname "${dst}")"
    info "link: ${dst} -> ${src}"
    ln -s "${src}" "${dst}"
}

# Conventions that need no declaration in module.sh.
link_conventional_paths() {
    local file

    if [[ -f "${MODULE_DIR}/shell.sh" ]]; then
        link shell.sh "${HOME}/.config/bash/rc.d/${MODULE}.sh"
    fi

    if [[ -d "${MODULE_DIR}/bin" ]]; then
        for file in "${MODULE_DIR}"/bin/*; do
            link "bin/$(basename "${file}")" "${HOME}/.local/bin/$(basename "${file}")"
        done
    fi
}

# Remove links from the previous run that this run no longer wants.
prune_stale_links() {
    local path

    if [[ -f "${LINK_MANIFEST}" ]]; then
        while IFS= read -r path; do
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
        done <"${LINK_MANIFEST}"
    fi

    mkdir -p "$(dirname "${LINK_MANIFEST}")"
    printf '%s' "${LINKED_PATHS}" >"${LINK_MANIFEST}"
}
