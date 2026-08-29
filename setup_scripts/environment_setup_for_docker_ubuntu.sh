#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
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

    # other
    htop
)
NPM_PACKAGES=(
    # JavaScript package manager used by some development workflows.
    yarn
)

# Basic PATH environment (nvm/cargo will be added later)
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

#=============================
# Pre-checks
#=============================
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Error: this script is for Ubuntu containers only." >&2
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

#=============================
# Finish: Persist environment variables
#=============================
persist_nvm_env_for_ubuntu

echo "Ubuntu Docker environment setup completed successfully."
echo
echo "NOTE: open a new shell (or run 'exec bash') before launching Neovim so that"
echo "      nvm's node is on \$PATH; otherwise Mason cannot install Node-based LSP"
echo "      servers such as pyright on the first launch."
