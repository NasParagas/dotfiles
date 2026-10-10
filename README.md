# dotfiles

## 環境

- Linux
  - Ubuntu 24.04〜26.04
- Mac
  - macOS 26〜27

## とりあえず必要なもの

```sh
# linux
sudo apt update
sudo apt install git
# ssh で入れるようにする
bash setup_scripts/ubuntu-host-minimal-setup.sh

# mac
xcode-select --install
```

## セットアップ

```sh
git clone https://github.com/NasParagas/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 1. ツールを入れる

```sh
### Ubuntu ###
# workstation: デスクトップ用。WezTerm・HackGen・Docker Engineを含む
# server: GUIなしのサーバー用。Docker Engineを含む1
# container: 開発コンテナ用。just・herdr・Docker Engineは入れない
bash setup_scripts/ubuntu_env_setup.sh container

# macOS
bash setup_scripts/environment_setup_for_host_macos.sh
```

- ツールのバージョンは`setup_scripts/versions.sh`で管理する。環境変数で上書きできる
  （例: `NEOVIM_VERSION=0.12.3 bash setup_scripts/...`）。
- Ubuntuで`sudo`なしに`docker`を使う場合は、`DOCKER_ADD_USER_TO_GROUP=true`を付けて実行する。

### 2. 設定ファイルをリンクする

```sh
bash setup_scripts/setup_config_symlink.sh
exec bash
```

