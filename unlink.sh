#!/usr/bin/env bash
set -euo pipefail

# Undo the symlinks made by install.sh and put back what they replaced.
# Installed packages and tools stay where they are.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

usage() {
    cat <<EOF
Usage: $(basename "$0") [--dry-run]

Remove the symlinks recorded by install.sh and restore the newest backup of
each path. Packages and tools installed by install.sh are not removed.

Options:
  --dry-run  Show what would change; change nothing
EOF
}

DRY_RUN=0

case "${1:-}" in
    "") ;;
    --dry-run) DRY_RUN=1 ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac

# shellcheck source=lib/common.sh
source "${REPO_ROOT}/lib/common.sh"
# shellcheck source=lib/link.sh
source "${REPO_ROOT}/lib/link.sh"

if [[ ! -f "${LINK_MANIFEST}" ]]; then
    info "no links recorded in ${LINK_MANIFEST}; nothing to do"
    exit 0
fi

run() {
    if ((DRY_RUN == 0)); then
        "$@"
    fi
}

latest_backup() {
    local candidate latest=""

    for candidate in "$1".backup-*; do
        if [[ -e "${candidate}" || -L "${candidate}" ]]; then
            latest="${candidate}"
        fi
    done

    printf '%s' "${latest}"
}

# Remove directories that are empty because their link is gone.
remove_empty_parents() {
    local dir
    dir="$(dirname "$1")"

    while [[ "${dir}" == "${HOME}/"* ]] && rmdir "${dir}" 2>/dev/null; do
        dir="$(dirname "${dir}")"
    done
}

KEPT=0

while IFS= read -r path; do
    if is_repo_link "${path}"; then
        info "remove link: ${path}"
        run rm "${path}"
    elif [[ -e "${path}" || -L "${path}" ]]; then
        warn "left alone, not a link into this repository: ${path}"
        KEPT=1
        continue
    fi

    backup="$(latest_backup "${path}")"
    if [[ -n "${backup}" ]]; then
        info "restore: ${backup} -> ${path}"
        run mv "${backup}" "${path}"
    elif ((DRY_RUN == 0)); then
        remove_empty_parents "${path}"
    fi
done < <(sort -u "${LINK_MANIFEST}")

if ((DRY_RUN == 0)); then
    rm "${LINK_MANIFEST}"
    remove_empty_parents "${LINK_MANIFEST}"
    info "links removed. Open a new shell to pick up the changes."
fi

if ((KEPT != 0)); then
    warn "some paths were left alone; check them by hand"
fi
