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
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/setup_components/just.sh"

setup_enable_tmp_cleanup

BREW_PACKAGES=(
    # Mandatory packages
    bash
    git
    curl
    wget

    # for neovim build
    ninja
    cmake
    gettext
    unzip

    # for neovim plugins and Mason installers
    ripgrep

    # others
    gnupg
)
NPM_PACKAGES=(
    # JavaScript package manager used by some development workflows.
    yarn
)

#=============================
# Pre-checks
#=============================
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Error: this script is for macOS hosts only." >&2
    exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
    echo "Error: Xcode Command Line Tools are required. Run: xcode-select --install" >&2
    exit 1
fi

if ! xcrun --find clang >/dev/null 2>&1; then
    echo "Error: clang from Xcode Command Line Tools was not found. Run: xcode-select --install" >&2
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is required. Install it from https://brew.sh/ and rerun this script." >&2
    exit 1
fi

#=============================
# Homebrew: Install base packages
#=============================
brew update
brew install "${BREW_PACKAGES[@]}"

# gettext is keg-only on Homebrew, so expose its commands for source builds.
GETTEXT_PREFIX="$(brew --prefix gettext)"
export PATH="${GETTEXT_PREFIX}/bin:${PATH}"

#=============================
# Shared developer tools
#=============================
install_rustup
load_cargo_env
install_tree_sitter_cli

install_nvm_node
install_npm_packages "${NPM_PACKAGES[@]}"

install_uv
install_lazygit_for_macos
install_neovim_from_source
install_hackgen_for_macos
install_just_for_macos

#=============================
# Finish
#=============================
BREW_BASH="$(brew --prefix)/bin/bash"
echo "macOS environment setup completed successfully."
echo "Homebrew Bash is installed at: ${BREW_BASH}"
echo "To use it as your login shell, add it to /etc/shells and run: chsh -s ${BREW_BASH}"
