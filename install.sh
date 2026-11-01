#!/usr/bin/env bash
set -euo pipefail

# 指定した profile における setup を実行する script
# 重複実行可能

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROFILE_DIR="${REPO_ROOT}/profiles"

print_usage() {
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

# 引数解析
PROFILE=""
LINK_ONLY=0

while (($# > 0)); do
    case "$1" in
    --link-only) LINK_ONLY=1 ;;
    -h | --help)
        print_usage
        exit 0
        ;;
    -*)
        print_usage >&2
        exit 2
        ;;
    *)
        if [[ -n "${PROFILE}" ]]; then
            print_usage >&2
            exit 2
        fi
        PROFILE="$1"
        ;;
    esac
    shift
done

# profile の指定漏れや、存在しない profile を弾く
if [[ -z "${PROFILE}" || ! -f "${PROFILE_DIR}/${PROFILE}.sh" ]]; then
    print_usage >&2
    exit 2
fi

# shellcheck source=lib/common.sh
source "${REPO_ROOT}/lib/common.sh"
# shellcheck source=lib/os.sh
source "${REPO_ROOT}/lib/os.sh"
# shellcheck source=lib/packages.sh
source "${REPO_ROOT}/lib/packages.sh"
# shellcheck source=lib/symlink.sh
source "${REPO_ROOT}/lib/symlink.sh"

trap cleanup_tmp_dirs EXIT
detect_os

# ---- 指定された profile の module を読み込む ----
MODULES=()
# shellcheck source=/dev/null
source "${PROFILE_DIR}/${PROFILE}.sh"

# 存在しない module の指定を検出
for MODULE in "${MODULES[@]}"; do
    [[ -d "${REPO_ROOT}/modules/${MODULE}" ]] || die "unknown module in profile '${PROFILE}': ${MODULE}"
done

# ---- module を順に処理 ----
for MODULE in "${MODULES[@]}"; do
    MODULE_DIR="${REPO_ROOT}/modules/${MODULE}"
    info "module: ${MODULE}"

    # 前の module の setup 関数を消す
    unset -f ensure_module_prerequisites create_module_symlinks install_module_extras 2>/dev/null || true

    if [[ -f "${MODULE_DIR}/module.sh" ]]; then
        # shellcheck source=/dev/null
        source "${MODULE_DIR}/module.sh"
    fi

    # -- 対象 module において対応する処理があれば実行する --
    if ((LINK_ONLY == 0)) && declare -F ensure_module_prerequisites >/dev/null; then
        ensure_module_prerequisites
    fi

    if ((LINK_ONLY == 0)); then
        install_packages_for_module "${MODULE_DIR}"
    fi

    symlink_module_dir_contents bin "${HOME}/.local/bin"
    symlink_module_dir_contents rc.d "${HOME}/.config/bash/rc.d"
    if declare -F create_module_symlinks >/dev/null; then
        create_module_symlinks
    fi

    if ((LINK_ONLY == 0)) && declare -F install_module_extras >/dev/null; then
        install_module_extras
    fi
done

# ---- 後片付け ----
prune_stale_symlinks
compact_symlink_manifest

info "profile '${PROFILE}' is ready. Open a new shell to pick up the changes."
