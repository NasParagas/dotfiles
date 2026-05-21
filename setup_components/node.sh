#!/usr/bin/env bash
# shellcheck shell=bash

# Node.js setup via nvm shared by host setup scripts.

install_nvm_node() {
    local nvm_version="${NVM_VERSION:?NVM_VERSION must be set}"
    local node_version="${NODE_VERSION:?NODE_VERSION must be set}"

    if [[ ! -d "${HOME}/.nvm" ]]; then
        curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh" | PROFILE=/dev/null bash
    fi

    export NVM_DIR="${HOME}/.nvm"
    # shellcheck source=/dev/null
    [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"

    if ! command -v nvm >/dev/null 2>&1; then
        echo "Error: nvm is not available after installation." >&2
        return 1
    fi

    nvm install "${node_version}"
    nvm alias default "${node_version}"
    nvm use "${node_version}"
}

install_npm_packages() {
    if (($# == 0)); then
        return 0
    fi

    npm install -g "$@"
}

persist_nvm_env_for_ubuntu() {
    sudo install -d /etc/profile.d
    sudo tee /etc/profile.d/nvm.sh >/dev/null <<'EOF'
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
EOF
    sudo chmod 644 /etc/profile.d/nvm.sh
}
