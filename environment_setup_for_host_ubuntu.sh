#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/versions.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/common.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/rust.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/tree_sitter.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/node.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/uv.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/lazygit.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/neovim.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/hackgen.sh"

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

    # for neovim plugins and Mason installers
    ripgrep

    # others
    gpg
    fontconfig
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
    echo "Error: this script is for Ubuntu hosts only." >&2
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

#=============================
# Finish: Persist environment variables
#=============================
persist_nvm_env_for_ubuntu

echo "Ubuntu host environment setup completed successfully."
