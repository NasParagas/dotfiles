#!/usr/bin/env bash
set -euo pipefail

#=============================================================================
# Ubuntu をセットアップしたあと、そこへ SSH で入るための最小環境を作るスクリプト。
# git は導入済みの前提。openssh-server を入れて sshd を起動する。
#=============================================================================

APT_PACKAGES=(
    # SSH でこのホストへ入るためのサーバ
    openssh-server
    # 他のホストへ入るためのクライアント一式
    # openssh-client
    # その他欲しいpackage
    vim
)

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
# APT: Install OpenSSH
#=============================
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"

#=============================
# Enable & start sshd
#=============================
# systemd 環境なら enable/start、そうでなければ service で起動する。
if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files ssh.service >/dev/null 2>&1; then
    sudo systemctl enable --now ssh
else
    sudo service ssh start
fi

#=============================
# Firewall: allow SSH (ufw があり有効なときだけ)
#=============================
if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q "Status: active"; then
    sudo ufw allow OpenSSH
fi

#=============================
# Finish: 接続先の案内
#=============================
echo
echo "OpenSSH server setup completed successfully."
echo
echo "接続先候補の IP アドレス:"
if command -v hostname >/dev/null 2>&1; then
    for ip in $(hostname -I 2>/dev/null); do
        echo "  ssh ${USER}@${ip}"
    done
fi
echo
echo "NOTE: 公開鍵認証を使う場合は、クライアント側から次を実行して鍵を登録してください。"
echo "      ssh-copy-id ${USER}@<this-host-ip>"
