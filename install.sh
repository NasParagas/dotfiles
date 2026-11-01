#!/usr/bin/env bash
set -euo pipefail

# 指定した profile における setup を実行する script
# 重複実行可能

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROFILE_DIR="${REPO_ROOT}/profiles"

# ---- 使い方の表示 ----
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

# ---- 引数の解析 ----
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

# profile の指定漏れや、存在しない profile を弾く
if [[ -z "${PROFILE}" || ! -f "${PROFILE_DIR}/${PROFILE}.sh" ]]; then
    usage >&2
    exit 2
fi

# ---- 共通処理の読み込みと OS 判定 ----
# shellcheck source=lib/common.sh
source "${REPO_ROOT}/lib/common.sh"
# shellcheck source=lib/os.sh
source "${REPO_ROOT}/lib/os.sh"
# shellcheck source=lib/link.sh
source "${REPO_ROOT}/lib/link.sh"

# 途中で失敗した場合にも tmp dir を削除
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

    # 前の module の関数が残らないように消す
    unset -f module_links module_install 2>/dev/null || true

    if [[ -f "${MODULE_DIR}/module.sh" ]]; then
        # shellcheck source=/dev/null
        source "${MODULE_DIR}/module.sh"
    fi

    # -- 対象 module において対応する処理があれば実行する --
    if ((LINK_ONLY == 0)) && [[ -f "${MODULE_DIR}/packages.${PKG_MANAGER}" ]]; then
        install_packages "${MODULE_DIR}/packages.${PKG_MANAGER}"
    fi

    if ((LINK_ONLY == 0)) && [[ "${PKG_MANAGER}" == "brew" && -f "${MODULE_DIR}/packages.cask" ]]; then
        install_casks "${MODULE_DIR}/packages.cask"
    fi

    # リンクを作る。bin/ と rc.d/ はリンク先が決まっていて、それ以外は module_links に書く
    link_contents bin "${HOME}/.local/bin"
    link_contents rc.d "${HOME}/.config/bash/rc.d"
    if declare -F module_links >/dev/null; then
        module_links
    fi

    # パッケージ以外のインストール処理を実行する
    if ((LINK_ONLY == 0)) && declare -F module_install >/dev/null; then
        module_install
    fi
done

# ---- 後片付け ----
# 今回の profile で使わなくなったリンクを削除する
prune_stale_links

info "profile '${PROFILE}' is ready. Open a new shell to pick up the changes."
