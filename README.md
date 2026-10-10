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
```

macOSでは、Xcode Command Line ToolsとHomebrew（<https://brew.sh/>）を先に入れておく。

```sh
# mac
xcode-select --install
```

## セットアップ

cloneする場所はどこでもよい（リンクはclone先を指す）。

```sh
git clone https://github.com/NasParagas/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 1. ツールを入れる

```sh
# Ubuntu: プロファイルを1つ選ぶ
bash setup_scripts/ubuntu_env_setup.sh workstation  # デスクトップ用。WezTerm・HackGen・Docker Engineを含む
bash setup_scripts/ubuntu_env_setup.sh server       # GUIなしのサーバー用。Docker Engineを含む
bash setup_scripts/ubuntu_env_setup.sh container    # 開発コンテナ用。just・herdr・Docker Engineは入れない

# macOS
bash setup_scripts/environment_setup_for_host_macos.sh
```

- Neovimは`~/neovim`でソースからビルドし、`sudo make install`で`/usr/local`に入れる。
- ツールのバージョンは`setup_scripts/versions.sh`で管理する。環境変数で上書きできる
  （例: `NEOVIM_VERSION=0.12.3 bash setup_scripts/...`）。
- Ubuntuで`sudo`なしに`docker`を使う場合は、`DOCKER_ADD_USER_TO_GROUP=true`を付けて実行する。

### 2. 設定ファイルをリンクする

```sh
bash setup_scripts/setup_config_symlink.sh
exec bash
```

`.bashrc`、`.bash_profile`、`.config/{aerospace,nvim,wezterm}`、clangdの設定をホームディレクトリへリンクする。
リンク先に既存のファイルがある場合は、`<名前>.backup-<日時>`に退避してからリンクする。

### SSHで入れるようにするだけの場合（Ubuntu）

```sh
bash setup_scripts/ubuntu-host-minimal-setup.sh
```

openssh-serverを入れてsshdを起動し、接続先のIPアドレスを表示する。

## 構成

```text
.bashrc / .bash_profile  シェル設定
.config/nvim/            Neovim設定（詳細は.config/nvim/README.md）
.config/wezterm/         WezTerm設定
.config/aerospace/       AeroSpace設定（macOS）
.config/clangd/          clangdのユーザー共通設定
setup_scripts/           OS・用途ごとのセットアップスクリプト
setup_components/        セットアップスクリプトが読み込む、ツールごとの導入処理
```

`.gitignore`はホワイトリスト形式なので、新しいファイルやディレクトリを管理対象にするときは追記が必要。
