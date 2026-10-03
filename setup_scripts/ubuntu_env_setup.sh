#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"

usage() {
    cat <<EOF
Usage: $(basename "$0") <profile>

Profiles:
  workstation  Ubuntu workstation with WezTerm, fonts, and Docker Engine
  server       Headless Ubuntu server with Docker Engine
  container    Ubuntu development container without host-only tools
EOF
}

if (($# != 1)); then
    usage >&2
    exit 2
fi

PROFILE="$1"
case "${PROFILE}" in
    workstation | server | container) ;;
    *)
        echo "Error: unknown Ubuntu setup profile: ${PROFILE}" >&2
        usage >&2
        exit 2
        ;;
esac

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/versions.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/common.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/rust.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/tree_sitter.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/node.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/uv.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/lazygit.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/neovim.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/hackgen.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/just.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/docker_ubuntu.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/herdr.sh"
# shellcheck source=/dev/null
source "${REPO_ROOT}/setup_components/opencode.sh"

setup_enable_tmp_cleanup

APT_PACKAGES=(
    # Mandatory packages
    git
    curl
    vim
    wget
    ca-certificates
    build-essential

    # for neovim build
    ninja-build
    cmake
    gettext
    unzip

    # for treesitter-cli
    clang
    libclang-dev
    libc6-dev

    # clangd LSP server (Mason has no prebuilt binary for Linux aarch64)
    clangd

    # for neovim plugins and Mason installers
    ripgrep

    # network utilities
    iproute2

    # other
    htop
)
NPM_PACKAGES=(
    # JavaScript package manager used by some development workflows.
    yarn
)

if [[ "${PROFILE}" == "workstation" ]]; then
    APT_PACKAGES+=(
        # for WezTerm and fonts
        gpg
        fontconfig
    )
fi

# Basic PATH environment (nvm/cargo will be added later)
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

#=============================
# Pre-checks
#=============================
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Error: this script is for Ubuntu environments only." >&2
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "Error: 'sudo' command not found. Please install sudo to run this script." >&2
    exit 1
fi

sudo -v || {
    echo "Error: Sudo privileges are required to run this script." >&2
    exit 1
}

#=============================
# APT: Install base packages
#=============================
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"

#=============================
# Shared developer tools
#=============================
install_rustup
load_cargo_env
install_tree_sitter_cli
persist_cargo_env_for_ubuntu

install_nvm_node
install_npm_packages "${NPM_PACKAGES[@]}"

install_uv
install_lazygit_for_linux
install_neovim_from_source
install_opencode

if [[ "${PROFILE}" != "container" ]]; then
    install_just_for_linux
    install_herdr
    install_docker_engine_for_ubuntu
fi

if [[ "${PROFILE}" == "workstation" ]]; then
    #=============================
    # WezTerm
    #=============================
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    sudo apt-get update -y
    sudo apt-get install -y --no-install-recommends wezterm-nightly

    #=============================
    # Fonts
    #=============================
    install_hackgen_for_linux
fi

#=============================
# Finish: Persist environment variables
#=============================
persist_nvm_env_for_ubuntu

echo "Ubuntu ${PROFILE} environment setup completed successfully."
echo
echo "NOTE: open a new shell (or run 'exec bash') before launching Neovim so that"
echo "      nvm's node is on \$PATH; otherwise Mason cannot install Node-based LSP"
echo "      servers such as pyright on the first launch."
