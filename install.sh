#!/usr/bin/env bash
set -euo pipefail

# Set up this machine from a profile. Safe to run repeatedly.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROFILE_DIR="${REPO_ROOT}/profiles"

usage() {
    cat <<EOF
Usage: $(basename "$0") <profile> [--link-only]

Profiles:
  mac          macOS host
  workstation  Ubuntu workstation with WezTerm, fonts and Docker Engine
  server       Headless Ubuntu server with Docker Engine
  container    Ubuntu development container without host-only tools

Options:
  --link-only  Only update symlinks; install nothing
EOF
}

PROFILE=""
LINK_ONLY=0

while (($# > 0)); do
    case "$1" in
        --link-only) LINK_ONLY=1 ;;
        -h | --help)
            usage
            exit 0
            ;;
        -*)
            usage >&2
            exit 2
            ;;
        *)
            if [[ -n "${PROFILE}" ]]; then
                usage >&2
                exit 2
            fi
            PROFILE="$1"
            ;;
    esac
    shift
done

if [[ -z "${PROFILE}" || ! -f "${PROFILE_DIR}/${PROFILE}.sh" ]]; then
    usage >&2
    exit 2
fi

# shellcheck source=lib/common.sh
source "${REPO_ROOT}/lib/common.sh"
# shellcheck source=lib/os.sh
source "${REPO_ROOT}/lib/os.sh"
# shellcheck source=lib/link.sh
source "${REPO_ROOT}/lib/link.sh"

trap cleanup_tmp_dirs EXIT

detect_os

MODULES=()
# shellcheck source=/dev/null
source "${PROFILE_DIR}/${PROFILE}.sh"

for MODULE in "${MODULES[@]}"; do
    [[ -d "${REPO_ROOT}/modules/${MODULE}" ]] || die "unknown module in profile '${PROFILE}': ${MODULE}"
done

for MODULE in "${MODULES[@]}"; do
    MODULE_DIR="${REPO_ROOT}/modules/${MODULE}"
    info "module: ${MODULE}"

    unset -f module_links module_install 2>/dev/null || true
    if [[ -f "${MODULE_DIR}/module.sh" ]]; then
        # shellcheck source=/dev/null
        source "${MODULE_DIR}/module.sh"
    fi

    if ((LINK_ONLY == 0)) && [[ -f "${MODULE_DIR}/packages.${PKG_MANAGER}" ]]; then
        install_packages "${MODULE_DIR}/packages.${PKG_MANAGER}"
    fi

    if ((LINK_ONLY == 0)) && [[ "${PKG_MANAGER}" == "brew" && -f "${MODULE_DIR}/packages.cask" ]]; then
        install_casks "${MODULE_DIR}/packages.cask"
    fi

    link_conventional_paths
    if declare -F module_links >/dev/null; then
        module_links
    fi

    if ((LINK_ONLY == 0)) && declare -F module_install >/dev/null; then
        module_install
    fi
done

prune_stale_links

info "profile '${PROFILE}' is ready. Open a new shell to pick up the changes."
