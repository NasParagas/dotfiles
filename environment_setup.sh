#!/usr/bin/env bash
set -euo pipefail
set -x

#=============================
# Configurable variables
#=============================
: "${WORK_DIR:=${HOME}/ws}"         # Workspace directory (can be overridden)
: "${BRANCH_NEOVIM:=master}"        # Neovim branch: stable or master
: "${DOTFILES_REPO:=https://github.com/NasParagas/dotfiles.git}"

export DEBIAN_FRONTEND=noninteractive

# Basic PATH environment (nvm/cargo will be added later)
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

#=============================
# Pre-checks
#=============================
# Verify if sudo is available and prompt for password if needed
if ! command -v sudo >/dev/null 2>&1; then
  echo "Error: 'sudo' command not found. Please install sudo to run this script." >&2
  exit 1
fi

# Ensure the user has sudo privileges
sudo -v || { echo "Error: Sudo privileges are required to run this script." >&2; exit 1; }

mkdir -p "${WORK_DIR}"

#=============================
# APT: Install base packages
#=============================
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean
sudo apt-get update -y

# Install packages (--no-install-recommends for lightweight installation)
sudo apt-get install -y --no-install-recommends \
  git vim wget curl ca-certificates openssl build-essential unzip \
  ninja-build gettext cmake llvm clang libclang-dev libssl-dev \
  libopencv-dev openssh-server pkg-config libtool autoconf automake

# Clear APT cache
sudo rm -rf /var/lib/apt/lists/*

#=============================
# Rust / Cargo (for tree-sitter-cli)
#=============================
# Install rustup non-interactively
if [[ ! -x "${HOME}/.cargo/bin/rustc" ]]; then
  # shellcheck disable=SC1117
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
fi

# Load cargo environment for current shell
if [[ -f "${HOME}/.cargo/env" ]]; then
  # shellcheck disable=SC1090
  source "${HOME}/.cargo/env"
fi

# Install tree-sitter CLI
if ! command -v tree-sitter >/dev/null 2>&1; then
  cargo install tree-sitter-cli || true
fi

# Add cargo to system-wide PATH (requires sudo)
sudo install -d /etc/profile.d
sudo tee /etc/profile.d/cargo_path.sh > /dev/null <<'EOF'
# cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
EOF
sudo chmod 644 /etc/profile.d/cargo_path.sh

#=============================
# Node.js / npm: nvm -> n
#=============================
# Install nvm (installs to user's $HOME/.nvm)
if [[ ! -d "${HOME}/.nvm" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Load nvm into current shell
export NVM_DIR="${HOME}/.nvm"
# shellcheck disable=SC1090
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"

# Install Node v24 via nvm
nvm install 24
node -v
npm -v

# Install 'n' globally via user's nvm
npm install -g n

# 'n' modifies /usr/local, so it requires root privileges.
# We find the exact path of 'n' installed by nvm and execute it with sudo.
N_BIN_PATH=$(which n)
sudo "${N_BIN_PATH}" latest
sudo "${N_BIN_PATH}" prune

# Prioritize the Node installed by 'n'
hash -r
node -v
npm -v

#=============================
# (Optional) LSP / Tools
#=============================
# Since 'n' installed Node to /usr/local, global installations now need sudo
sudo npm install -g pyright typescript typescript-language-server yarn

#=============================
# Neovim: Build and install from source
#=============================
cd "${WORK_DIR}"

# Clean up existing directory if present
if [[ -d "${WORK_DIR}/neovim" ]]; then
  rm -rf "${WORK_DIR}/neovim"
fi

git clone https://github.com/neovim/neovim --branch "${BRANCH_NEOVIM}" --depth 1
cd neovim

# Build with RelWithDebInfo
make CMAKE_BUILD_TYPE=RelWithDebInfo
# Installation requires root privileges
sudo make install

# Remove source to save space
cd "${WORK_DIR}"
rm -rf "${WORK_DIR}/neovim"

#=============================
# dotfiles: Fetch and symlink
#=============================
cd "${WORK_DIR}"

if [[ -d "${WORK_DIR}/dotfiles" ]]; then
  # Pull updates if directory exists
  cd "${WORK_DIR}/dotfiles"
  git pull --rebase --autostash || true
else
  git clone "${DOTFILES_REPO}"
  cd "${WORK_DIR}/dotfiles"
fi

# Run setup script (now runs as the regular user, linking to user's $HOME)
if [[ -x "./setup_config_symlink.sh" ]]; then
  ./setup_config_symlink.sh
else
  echo "WARN: setup_config_symlink.sh not found or not executable in dotfiles repo." >&2
fi

cd "${WORK_DIR}"

#=============================
# Finish: Persist environment variables
#=============================
# Auto-load nvm on login (requires sudo to write to /etc/profile.d)
sudo tee /etc/profile.d/nvm.sh > /dev/null <<'EOF'
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
EOF
sudo chmod 644 /etc/profile.d/nvm.sh

echo "Neovim environment setup completed successfully."
