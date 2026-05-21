#!/usr/bin/env bash
# shellcheck shell=bash

# Rust toolchain setup shared by host setup scripts.

install_rustup() {
    if [[ ! -x "${HOME}/.cargo/bin/rustc" ]]; then
        curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
    fi
}

load_cargo_env() {
    if [[ -f "${HOME}/.cargo/env" ]]; then
        # shellcheck source=/dev/null
        source "${HOME}/.cargo/env"
    fi
}

persist_cargo_env_for_ubuntu() {
    sudo install -d /etc/profile.d
    sudo tee /etc/profile.d/cargo_path.sh >/dev/null <<'EOF'
# cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
EOF
    sudo chmod 644 /etc/profile.d/cargo_path.sh
}
