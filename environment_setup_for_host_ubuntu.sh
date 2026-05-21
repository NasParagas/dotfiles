#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/versions.sh"

### configuration variable ###
NEOVIM_TAG="v${NEOVIM_VERSION#v}"
# These packages will be installed
APT_PACKAGES=(
    # Mandantry packages
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

    # for neovim plugins
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

TMP_DIRS=()
cleanup_tmp_dirs() {
    if ((${#TMP_DIRS[@]} > 0)); then
        rm -rf "${TMP_DIRS[@]}"
    fi
}
trap cleanup_tmp_dirs EXIT

#=============================
# Pre-checks
#=============================
# Verify if sudo is available and prompt for password if needed
if ! command -v sudo >/dev/null 2>&1; then
    echo "Error: 'sudo' command not found. Please install sudo to run this script." >&2
    exit 1
fi

# Ensure the user has sudo privileges
sudo -v || {
    echo "Error: Sudo privileges are required to run this script." >&2
    exit 1
}

#=============================
# APT: Install base packages
#=============================
sudo apt-get update -y

# Install packages
sudo apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"

#=============================
# Rust / Cargo (for tree-sitter-cli)
#=============================
# Install rustup
if [[ ! -x "${HOME}/.cargo/bin/rustc" ]]; then
    # shellcheck disable=SC1117
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
fi

# Load cargo environment for current shell
if [[ -f "${HOME}/.cargo/env" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
fi

# Install tree-sitter CLI
TREE_SITTER_INSTALLED_VERSION=""
if command -v tree-sitter >/dev/null 2>&1; then
    TREE_SITTER_INSTALLED_VERSION="$(tree-sitter --version | awk '{print $2}')"
fi

if [[ "${TREE_SITTER_INSTALLED_VERSION}" != "${TREE_SITTER_CLI_VERSION}" ]]; then
    cargo install tree-sitter-cli --version "${TREE_SITTER_CLI_VERSION}" --locked
fi

# Add cargo to system-wide PATH (requires sudo)
sudo install -d /etc/profile.d
sudo tee /etc/profile.d/cargo_path.sh >/dev/null <<'EOF'
# cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
EOF
sudo chmod 644 /etc/profile.d/cargo_path.sh

#=============================
# Node.js / npm: nvm
#=============================
# Install nvm (installs to user's $HOME/.nvm)
if [[ ! -d "${HOME}/.nvm" ]]; then
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | PROFILE=/dev/null bash
fi

# Load nvm into current shell
export NVM_DIR="${HOME}/.nvm"
# shellcheck source=/dev/null
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"

if ! command -v nvm >/dev/null 2>&1; then
    echo "Error: nvm is not available after installation." >&2
    exit 1
fi

# Install Node via nvm
nvm install "${NODE_VERSION}"
nvm alias default "${NODE_VERSION}"
nvm use "${NODE_VERSION}"

#=============================
# (Optional) LSP / Tools
#=============================
npm install -g "${NPM_PACKAGES[@]}"

#=============================
# uv
#=============================
export PATH="${HOME}/.local/bin:${PATH}"
if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi
uv --version

#===============================
# Others
#=============================
# lazygit
LAZYGIT_ARCH="$(uname -m | sed -e 's/aarch64/arm64/')"
LAZYGIT_TMP_DIR="$(mktemp -d)"
TMP_DIRS+=("${LAZYGIT_TMP_DIR}")

curl -fL \
    -o "${LAZYGIT_TMP_DIR}/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${LAZYGIT_ARCH}.tar.gz"

tar xf "${LAZYGIT_TMP_DIR}/lazygit.tar.gz" -C "${LAZYGIT_TMP_DIR}" lazygit
sudo install -m 0755 "${LAZYGIT_TMP_DIR}/lazygit" /usr/local/bin/lazygit

#=============================
# Neovim: Build and install from source
#=============================
NEOVIM_DIR="${HOME}/neovim"

if [[ -d "${NEOVIM_DIR}/.git" ]]; then
    git -C "${NEOVIM_DIR}" fetch --depth 1 origin "refs/tags/${NEOVIM_TAG}:refs/tags/${NEOVIM_TAG}"
    git -C "${NEOVIM_DIR}" checkout --detach "${NEOVIM_TAG}"
elif [[ -e "${NEOVIM_DIR}" ]]; then
    echo "Error: ${NEOVIM_DIR} exists but is not a git repository." >&2
    exit 1
else
    git clone https://github.com/neovim/neovim --branch "${NEOVIM_TAG}" --depth 1 "${NEOVIM_DIR}"
fi

cd "${NEOVIM_DIR}"
make CMAKE_BUILD_TYPE=Release

### Wezterm installation
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends wezterm-nightly

#=============================
# Font: HackGen
#=============================
HACKGEN_TMP_DIR="$(mktemp -d)"
TMP_DIRS+=("${HACKGEN_TMP_DIR}")
HACKGEN_ZIP_NAME="HackGen_NF_v${HACKGEN_VERSION}.zip"
HACKGEN_EXTRACT_DIR="${HACKGEN_TMP_DIR}/HackGen_NF_v${HACKGEN_VERSION}"
HACKGEN_FONT_DIR="${HOME}/.local/share/fonts/HackGen"

curl -fL \
    -o "${HACKGEN_TMP_DIR}/${HACKGEN_ZIP_NAME}" \
    "https://github.com/yuru7/HackGen/releases/download/v${HACKGEN_VERSION}/${HACKGEN_ZIP_NAME}"

unzip -q "${HACKGEN_TMP_DIR}/${HACKGEN_ZIP_NAME}" -d "${HACKGEN_TMP_DIR}"
install -d -m 0755 "${HACKGEN_FONT_DIR}"
install -m 0644 \
    "${HACKGEN_EXTRACT_DIR}/HackGen35ConsoleNF-Regular.ttf" \
    "${HACKGEN_EXTRACT_DIR}/HackGen35ConsoleNF-Bold.ttf" \
    "${HACKGEN_FONT_DIR}/"
fc-cache -f "${HACKGEN_FONT_DIR}"
fc-match "HackGen35 Console NF"

#=============================
# Finish: Persist environment variables
#=============================
# Auto-load nvm on login (requires sudo to write to /etc/profile.d)
sudo tee /etc/profile.d/nvm.sh >/dev/null <<'EOF'
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
EOF
sudo chmod 644 /etc/profile.d/nvm.sh

echo "Ubuntu environment setup completed successfully."
